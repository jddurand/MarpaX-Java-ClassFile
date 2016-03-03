use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPoolArray;

# ABSTRACT: Java .class's cp_info parsing

# VERSION

# AUTHORITY

use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use Scalar::Util qw/blessed/;
use Types::Common::Numeric qw/PositiveOrZeroInt/;
use Types::Standard -all;
use constant {
  ACC_INTERFACE  => 0x0200
};

=head1 DESCRIPTION

MarpaX::Java::ClassFile::ConstantPoolArray is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('utf8Length$'  => \&_utf8LengthCallback,
                  'cpInfo$'      => \&_cpInfoCallback,
                  '^longBytes'   => \&_longBytesCallback,
                  '^doubleBytes' => \&_doubleBytesCallback
                 );

#
# Private grammars
#
my %_GRAMMARS =
  map
  { $_ => Marpa::R2::Scanless::G->new({source => __PACKAGE__->section_data($_)}) }
  qw/fieldName methodName fieldDescriptor methodDescriptor/;

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ------------
# Our thingies
# ------------
has classFiles      => ( is => 'ro', isa => HashRef[InstanceOf['MarpaX::Java::ClassFile']], default => sub { {} } );
has majorVersion    => ( is => 'ro', isa => PositiveOrZeroInt, required => 1);
has minorVersion    => ( is => 'ro', isa => PositiveOrZeroInt, required => 1);
has _lastTag        => ( is => 'rw', isa => PositiveOrZeroInt, default => sub { 0 });  # Tag with value 0 does not exist -;
has _skipNextEntry  => ( is => 'rw', isa => Bool,              default => sub { 0 });

# ---------------
# Event callbacks
# ---------------
sub _utf8LengthCallback {
  my ($self) = @_;

  my $utf8Length = $self->literalU2;
  my $utf8String = $utf8Length ? substr($self->input, $self->pos, $utf8Length) : undef;
  $self->tracef('Modified UTF-8: %s', $utf8String);
  $self->lexeme_read('MANAGED', $utf8Length, $utf8String);  # Note: this lexeme_read() handles case of length 0
}

sub _cpInfoCallback {
  my ($self) = @_;
  $self->_nbDone($self->_nbDone + 1);
  $self->max($self->pos) if ($self->_nbDone >= $self->size); # Set the max position so that parsing end
  if ($self->_skipNextEntry) {
    $self->_skipNextEntry(0);
    if ($self->_nbDone < $self->size) {
      $self->debugf('Pushing undef as next entry');
      $self->lexeme_read('MANAGED', 0, undef);               # This will retrigger cpInfo$ event
    }
  }
}

sub _setSkipNextEntry {
  my ($self) = @_;
  $self->debugf('Say next eventual entry should be undef');
  $self->_skipNextEntry(1);
}

sub _longBytesCallback   { goto &_setSkipNextEntry }
sub _doubleBytesCallback { goto &_setSkipNextEntry }

# --------------------
# Our grammar actions
# --------------------
my %_ARG2HASH =
  (
   CONSTANT_Class_info              => [qw/tag name_index/],
   CONSTANT_Fieldref_info           => [qw/tag class_index name_and_type_index/],
   CONSTANT_Methodref_info          => [qw/tag class_index name_and_type_index/],
   CONSTANT_InterfaceMethodref_info => [qw/tag class_index name_and_type_index/],
   CONSTANT_String_info             => [qw/tag string_index/],
   CONSTANT_Integer_info            => [qw/tag computed_value/],
   CONSTANT_Float_info              => [qw/tag computed_value/],
   CONSTANT_Long_info               => [qw/tag computed_value/],
   CONSTANT_Double_info             => [qw/tag computed_value/],
   CONSTANT_NameAndType_info        => [qw/tag name_index descriptor_index/],
   CONSTANT_Utf8_info               => [qw/tag length computed_value/],
   CONSTANT_MethodHandle_info       => [qw/tag reference_kind reference_index/],
   CONSTANT_MethodType_info         => [qw/tag descriptor_index/],
   CONSTANT_InvokeDynamic_info      => [qw/tag bootstrap_method_attr_index name_and_type_index/]
  );

sub _arg2hash {
  my ($self, $struct, @args) = @_;

  my $descArrayRef = $_ARG2HASH{$struct};
  my %hash = map { $descArrayRef->[$_] => $args[$_] } 0..$#args;
  bless \%hash, $struct
}

sub _constantClassInfo              { $_[0]->_arg2hash('CONSTANT_Class_info',              @_[1..$#_]) }
sub _constantFieldrefInfo           { $_[0]->_arg2hash('CONSTANT_Fieldref_info',           @_[1..$#_]) }
sub _constantMethodrefInfo          { $_[0]->_arg2hash('CONSTANT_Methodref_info',          @_[1..$#_]) }
sub _constantInterfaceMethodrefInfo { $_[0]->_arg2hash('CONSTANT_InterfaceMethodref_info', @_[1..$#_]) }
sub _constantStringInfo             { $_[0]->_arg2hash('CONSTANT_String_info',             @_[1..$#_]) }
sub _constantIntegerInfo            { $_[0]->_arg2hash('CONSTANT_Integer_info',            @_[1..$#_]) }
sub _constantFloatInfo              { $_[0]->_arg2hash('CONSTANT_Float_info',              @_[1..$#_]) }
sub _constantLongInfo               { $_[0]->_arg2hash('CONSTANT_Long_info',               @_[1..$#_]) }
sub _constantDoubleInfo             { $_[0]->_arg2hash('CONSTANT_Double_info',             @_[1..$#_]) }
sub _constantNameAndTypeInfo        { $_[0]->_arg2hash('CONSTANT_NameAndType_info',        @_[1..$#_]) }
sub _constantUtf8Info               { $_[0]->_arg2hash('CONSTANT_Utf8_info',               @_[1..$#_]) }
sub _constantMethodHandleInfo       { $_[0]->_arg2hash('CONSTANT_MethodHandle_info',       @_[1..$#_]) }
sub _constantMethodType             { $_[0]->_arg2hash('CONSTANT_MethodType_info',         @_[1..$#_]) }
sub _constantInvokeDynamic          { $_[0]->_arg2hash('CONSTANT_InvokeDynamic_info',      @_[1..$#_]) }

#
# Take care: index means indice-1
#
sub _checkSubIndex {
  my ($self, $item, $itemIndex, $subIndex, $cpInfo, $min, $max) = @_;
  $self->fatalf('%s (constant pool item No %d) references an invalid index %d (min=%d, max=%d)',
                blessed($item),
                $itemIndex,
                $subIndex,
                $min, $max) unless (($subIndex >= $min) && ($subIndex <= $max))
}

sub _checkSubIndexType {
  my ($self, $item, $itemIndex, $subIndex, $itemsArrayRef, $subType) = @_;
  my $subItem = $itemsArrayRef->[$subIndex - 1];
  my $blessed = blessed($subItem) // '';
  $self->fatalf('%s (constant pool item No %d) references an entry that is of type %s intead of %s',
                blessed($item),
                $itemIndex,
                $blessed,
                $subType) unless ($blessed eq $subType)
}
#
# Default constraints are always on minIndex and maxIndex, and they are always
# "inherited"
#
sub _checkConstantPoolItem {
  my ($self, $parentIdArrayRef, $cpInfoArrayRef, $itemIndex, %constraint)  = @_;

  $parentIdArrayRef //= [];
  my $parentIds = @{$parentIdArrayRef} ? '[' . join('->', @{$parentIdArrayRef}) . '] ' : '';
  $self->tracef('%sChecking item at index %d', $parentIds, $itemIndex);

  # ---------------------
  # minIndex constraint ?
  # ---------------------
  if (defined($constraint{minIndex})) {
    $self->tracef('%sItem index %d is >= %d ?', $parentIds, $itemIndex, $constraint{minIndex});
    $self->fatalf('%sItem index %d must be >= %d', $itemIndex, $constraint{minIndex}) unless ($itemIndex >= $constraint{minIndex})
  }

  # ---------------------
  # maxIndex constraint ?
  # ---------------------
  if (defined($constraint{maxIndex})) {
    $self->tracef('%sItem index %d is <= %d ?', $parentIds, $itemIndex, $constraint{maxIndex});
    $self->fatalf('%sItem index %d must be <= %d', $parentIds, $itemIndex, $constraint{maxIndex}) unless ($itemIndex <= $constraint{maxIndex})
  }

  my $item = $cpInfoArrayRef->[$itemIndex - 1];
  return unless (defined($item));

  my $blessed = blessed($item) // '';

  # --------------------
  # Blessed constraint ?
  # --------------------
  if (defined($constraint{blessed})) {
    if (ref($constraint{blessed})) {
      $self->tracef('%sItem index %d is one of %s ?', $parentIds, $itemIndex, $constraint{blessed});
      $self->fatalf('%sItem index %d is %s, not one of %s', $parentIds, $itemIndex, $blessed, $constraint{blessed}) unless (grep { $blessed eq $_ } @{$constraint{blessed}});
    } else {
      $self->tracef('%sItem index %d is a %s ?', $parentIds, $itemIndex, $constraint{blessed});
      $self->fatalf('%sItem index %d is %s, not %s', $parentIds, $itemIndex, $blessed, $constraint{blessed}) unless ($constraint{blessed} eq $blessed);
    }
  } else {
    if ($blessed) {
      $self->tracef('%sItem index %d is a %s', $parentIds, $itemIndex, $blessed);
    } else {
      $self->tracef('%sItem index %d is not blessed', $parentIds, $itemIndex);
    }
  }

  if
    # *******************************
    ($blessed eq 'CONSTANT_Class_info')
    # *******************************
    {
      #
      # The value of the name_index item must be a valid index into the constant_pool table.
      # The constant_pool entry at that index must be a CONSTANT_Utf8_info structure.
      #
      push(@{$parentIdArrayRef}, $itemIndex);
      $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{name_index}, %constraint, blessed => 'CONSTANT_Utf8_info');
      pop(@{$parentIdArrayRef});
    }
  elsif
    # ********************************
    ($blessed eq 'CONSTANT_Utf8_info')
    # ********************************
    {
      # --------------------
      # grammar constraint ?
      # --------------------
      if (defined($constraint{grammarName})) {
        my $grammarName = $constraint{grammarName};
        $self->tracef('%sItem index %d passes grammar %s on %s ?', $parentIds, $itemIndex, $grammarName, $item->{computed_value});
        $item->{parseTreeValue} //= {};
        if (! defined($item->{parseTreeValue}->{$grammarName})) {
          my $parseTreeValueRef = $_GRAMMARS{$grammarName}->parse(\$item->{computed_value});
          my $parseTreeValue = ${$parseTreeValueRef};
          $item->{parseTreeValue}->{$grammarName} = $parseTreeValue;
        }
      }
    }
  elsif
    # ***************************************
    ($blessed eq 'CONSTANT_MethodHandle_info')
    # ****************************************
    {
      #
      # The value of the reference_kind item must be in the range 1 to 9. The value denotes the kind of this method handle, which characterizes its bytecode behavior.
      #
      my $referenceKind = $item->{reference_kind};
      $self->tracef('%sItem index %d reference_kind %s is inside range [1-9] ?',
                    $parentIds,
                    $itemIndex,
                    $referenceKind);
      $self->fatalf('%sItem index %d has a reference_kind item outside of range [1-9]: %s',
                    $parentIds,
                    $itemIndex,
                    $referenceKind) unless (($referenceKind >= 1) && ($referenceKind <= 9));
      #
      # The value of the reference_index item must be a valid index into the constant_pool table.
      # The constant_pool entry at that index must be as follows:
      #
      # If the value of the reference_kind item is 1 (REF_getField), 2 (REF_getStatic), 3 (REF_putField), or 4 (REF_putStatic),
      # then the constant_pool entry at that index must be a CONSTANT_Fieldref_info.
      #
      my $referedItem;
      if (($referenceKind >= 1) && ($referenceKind <= 4)) {
        push(@{$parentIdArrayRef}, $itemIndex);
        $referedItem = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{reference_index}, %constraint, blessed => 'CONSTANT_Fieldref_info');
        pop(@{$parentIdArrayRef});
      }
      #
      # If the value of the reference_kind item is 5 (REF_invokeVirtual) or 8 (REF_newInvokeSpecial),
      # then the constant_pool entry at that index must be a CONSTANT_Methodref_info.
      #
      if (($referenceKind == 5) || ($referenceKind == 8)) {
        push(@{$parentIdArrayRef}, $itemIndex);
        $referedItem = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{reference_index}, %constraint, blessed => 'CONSTANT_Methodref_info');
        pop(@{$parentIdArrayRef});
      }
      #
      # If the value of the reference_kind item is 6 (REF_invokeStatic) or 7 (REF_invokeSpecial),
      # then
      # - if the class file version number is less than 52.0, the constant_pool entry at that index must be a CONSTANT_Methodref_info
      # - if the class file version number is 52.0 or above, the constant_pool entry at that index must be either a CONSTANT_Methodref_info or a CONSTANT_InterfaceMethodref_info.
      #
      if (($referenceKind == 6) || ($referenceKind == 7)) {
        my $version = $self->majorVersion . '.' . $self->minorVersion;
        if ($version < 52.0) {
          push(@{$parentIdArrayRef}, $itemIndex);
          $referedItem = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{reference_index}, %constraint, blessed => 'CONSTANT_Methodref_info');
          pop(@{$parentIdArrayRef});
        } else {
          push(@{$parentIdArrayRef}, $itemIndex);
          $referedItem = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{reference_index}, %constraint, blessed => [qw/CONSTANT_Methodref_info CONSTANT_InterfaceMethodref_info/]);
          pop(@{$parentIdArrayRef});
        }
      }
      #
      # If the value of the reference_kind item is 9 (REF_invokeInterface),
      # then the constant_pool entry at that index must be a CONSTANT_InterfaceMethodref_info
      #
      if ($referenceKind == 9) {
        push(@{$parentIdArrayRef}, $itemIndex);
        $referedItem = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{reference_index}, %constraint, blessed => 'CONSTANT_InterfaceMethodref_info');
        pop(@{$parentIdArrayRef});
      }
      #
      # If the value of the reference_kind item is 5 (REF_invokeVirtual), 6 (REF_invokeStatic), 7 (REF_invokeSpecial), or 9 (REF_invokeInterface), the name of the method represented by a CONSTANT_Methodref_info or a CONSTANT_InterfaceMethodref_info must not be <init> or <clinit>.
      #
      if ((($referenceKind >= 5) && ($referenceKind <= 7)) || $referenceKind == 9) {
        push(@{$parentIdArrayRef}, $itemIndex);
        my $nameAndTypeInfo = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $referedItem->{name_and_type_index}, %constraint, blessed => 'CONSTANT_NameAndType_info');
        pop(@{$parentIdArrayRef});
        my $utf8Info = $cpInfoArrayRef->[$nameAndTypeInfo->{name_index} - 1];
        my $methodName = $utf8Info->{computed_value};
        $self->tracef('%sItem index %d refers to a method name %s that is not <init> or <clinit> ?',
                    $parentIds,
                    $itemIndex,
                    $methodName);
      $self->fatalf('%sItem index %d refers to a method name %s that must not be <init> or <clinit>',
                    $parentIds,
                    $itemIndex,
                    $methodName) if (($methodName eq '<init>') || ($methodName eq '<clinit>'));
      }
      #
      # If the value is 8 (REF_newInvokeSpecial), the name of the method represented by a CONSTANT_Methodref_info structure must be <init>.
      #
      if ($referenceKind == 8) {
        push(@{$parentIdArrayRef}, $itemIndex);
        my $nameAndTypeInfo = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $referedItem->{name_and_type_index}, %constraint, blessed => 'CONSTANT_NameAndType_info');
        pop(@{$parentIdArrayRef});
        my $utf8Info = $cpInfoArrayRef->[$nameAndTypeInfo->{name_index} - 1];
        my $methodName = $utf8Info->{computed_value};
        $self->tracef('%sItem index %d refers to a method name %s that is <init> ?',
                    $parentIds,
                    $itemIndex,
                    $methodName);
      $self->fatalf('%sItem index %d refers to a method name %s that must be <init>',
                    $parentIds,
                    $itemIndex,
                    $methodName) unless ($methodName eq '<init>');
      }
    }
  elsif
    # ***************************************
    ($blessed eq 'CONSTANT_NameAndType_info')
    # ***************************************
    {
      #
      # Make sure constraint dispatching is correct: there are two values inside this single entry
      #
      my $methodOrFieldName       = delete($constraint{methodOrFieldName});
      my $methodOrFieldDescriptor = delete($constraint{methodOrFieldDescriptor});
      #
      # The value of the name_index item must be a valid index into the constant_pool table.
      # The constant_pool entry at that index must be a CONSTANT_Utf8_info structure representing either the special method name <init> or a valid unqualified name denoting a field or method (§4.2.2).
      #
      push(@{$parentIdArrayRef}, $itemIndex);
      $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{name_index}, %constraint, grammarName => $methodOrFieldName, blessed => 'CONSTANT_Utf8_info');
      pop(@{$parentIdArrayRef});
      #
      # The value of the descriptor_index item must be a valid index into the constant_pool table.
      # The constant_pool entry at that index must be a CONSTANT_Utf8_info structure representing a valid field descriptor or method descriptor
      #
      push(@{$parentIdArrayRef}, $itemIndex);
      $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{descriptor_index}, %constraint, grammarName => $methodOrFieldDescriptor, blessed => 'CONSTANT_Utf8_info');
      pop(@{$parentIdArrayRef});
    }
  elsif
    # ************************************************
    ($blessed eq 'CONSTANT_Fieldref_info'           ||
     $blessed eq 'CONSTANT_Methodref_info'          ||
     $blessed eq 'CONSTANT_InterfaceMethodref_info')
    # ************************************************
    {
      #
      # The value of the class_index item must be a valid index into the constant_pool table.
      # The constant_pool entry at that index must be a CONSTANT_Class_info structure.
      #
      push(@{$parentIdArrayRef}, $itemIndex);
      my $classInfo = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{class_index}, %constraint, blessed => 'CONSTANT_Class_info');
      pop(@{$parentIdArrayRef});
      #
      # The class_index item of a CONSTANT_Methodref_info structure must be a class type.
      # The class_index item of a CONSTANT_InterfaceMethodref_info structure must be an interface type.
      # The class_index item of a CONSTANT_Fieldref_info structure may be either a class type or an interface type.
      #
      my $utf8Info = $cpInfoArrayRef->[$classInfo->{name_index} - 1];
      my $className = $utf8Info->{computed_value};
      if (exists($self->classFiles->{$className})) {
        #
        # If not an interface, then this is class
        #
        my $accessFlags = $self->classFiles->{$className}->ast->{accessFlags};
        my $isInterface = (($accessFlags->{u2} & ACC_INTERFACE) == ACC_INTERFACE) ? 1 : 0;
        my $isClass     = $isInterface ? 0 : 1;
        if ($blessed eq 'CONSTANT_Methodref_info') {
          $self->fatalf('%sItem index %d references a ClassFile named %s that is not a class, but: %s',
                        $parentIds,
                        $itemIndex,
                        $className,
                        $accessFlags->{computed_value}) unless ($isClass);
        } elsif ($blessed eq 'CONSTANT_InterfaceMethodref_info') {
          $self->fatalf('%sItem index %d references a ClassFile named %s that is not an interface, but: %s',
                        $parentIds,
                        $itemIndex,
                        $className,
                        $accessFlags->{computed_value}) unless ($isInterface);
        }
      } else {
        #
        # Should we pollute logging with that
        #
        # $self->infof('Constant pool No %d, type %s, references a class name %s that is not loaded: cannot check if this is a class or an interface', $itemIndex, $blessed, $className)
      }
      #
      # The value of the name_and_type_index must be a valid index into the constant_pool table.
      # The constant_pool entry at that index must be a CONSTANT_NameAndType_info structure.
      #
      #
      # In a CONSTANT_Fieldref_info, the indicated descriptor must be a field descriptor.
      # Otherwise, the indicated descriptor must be a method descriptor.
      #
      my ($methodOrFieldName, $methodOrFieldDescriptor) = ($blessed eq 'CONSTANT_Fieldref_info') ? ('fieldName', 'fieldDescriptor') : ('methodName', 'methodDescriptor');

      push(@{$parentIdArrayRef}, $itemIndex);
      my $nameAndTypeInfo = $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{name_and_type_index}, %constraint,
                                              blessed => 'CONSTANT_NameAndType_info',
                                              methodOrFieldName => $methodOrFieldName,
                                              methodOrFieldDescriptor => $methodOrFieldDescriptor);
      pop(@{$parentIdArrayRef});
      #
      # If the name of the method of a CONSTANT_Methodref_info structure begins with a '<' ('\u003c'),
      # then the name must be the special name <init>, representing an instance initialization method.
      # The return type of such a method must be void.
      #
      if ($blessed eq 'CONSTANT_Methodref_info') {
        $utf8Info = $cpInfoArrayRef->[$nameAndTypeInfo->{name_index} - 1];
        my $methodName = $utf8Info->{computed_value};
        if (substr($methodName, 0, 1) eq '<') {
          $self->fatalf('%sItem index %d references a method name %s instead of %s',
                        $parentIds,
                        $itemIndex,
                        $methodName,
                        '<init>') unless ($methodName eq '<init>');
          $utf8Info = $cpInfoArrayRef->[$nameAndTypeInfo->{descriptor_index} - 1];
          my $methodDescriptor = $utf8Info->{parseTreeValue}->{methodDescriptor};
          my $ReturnDescriptor = $methodDescriptor->{ReturnDescriptor};
          $self->fatalf('%sItem index %d references a method whose return type is %s instead of being blessed to %s',
                        $parentIds,
                        $itemIndex,
                        $ReturnDescriptor,
                        'VoidDescriptor') unless (blessed($ReturnDescriptor) eq 'VoidDescriptor');
        }
      }
    }
  elsif
    # **************************************
    ($blessed eq 'CONSTANT_MethodType_info')
    # **************************************
    {
      #
      # The value of the descriptor_index item must be a valid index into the constant_pool table.
      # The constant_pool entry at that index must be a CONSTANT_Utf8_info structure representing a method descriptor.
      #
      push(@{$parentIdArrayRef}, $itemIndex);
      $self->_checkConstantPoolItem($parentIdArrayRef, $cpInfoArrayRef, $item->{descriptor_index}, %constraint,
                                              blessed => 'CONSTANT_Utf8_info',
                                              methodOrFieldDescriptor => 'methodDescriptor');
      pop(@{$parentIdArrayRef});
    }

  $item
}

sub _cpInfoArray {
  my ($self, @cpInfo) = @_;

  my ($minIndex, $maxIndex) = (1, scalar(@cpInfo));
  my @commonArgs = (\@cpInfo, 1, scalar(@cpInfo));

  [ map { $self->_checkConstantPoolItem(undef, \@cpInfo, $_, minIndex => $minIndex, maxIndex => $maxIndex) } ($minIndex..$maxIndex) ]
}

sub _MethodDescriptor {
  my ($self, $ParameterDescriptors, $ReturnDescriptor) = @_;

  return { ParameterDescriptors => $ParameterDescriptors, ReturnDescriptor => $ReturnDescriptor }
}

sub _ClassName {
  my ($self, @UnqualifiedName) = @_;

  join('/', @UnqualifiedName)
}

sub _BaseType {
  my ($self, $value) = @_;

  return bless(\$value, 'BaseType')
}

sub _ObjectType {
  my ($self, $value) = @_;

  return bless(\$value, 'ObjectType')
}

sub _ArrayType {
  my ($self, $value) = @_;

  return bless(\$value, 'ArrayType')
}

sub _VoidDescriptor {
  my ($self, $value) = @_;

  return bless(\$value, 'VoidDescriptor')
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'cpInfo$'      = completed cpInfo
event 'utf8Length$'  = completed utf8Length
event '^longBytes'   = predicted longBytes
event '^doubleBytes' = predicted doubleBytes

cpInfoArray ::= cpInfo*       action => _cpInfoArray
cpInfo ::=
    constantClassInfo
  | constantFieldrefInfo
  | constantMethodrefInfo
  | constantInterfaceMethodrefInfo
  | constantStringInfo
  | constantIntegerInfo
  | constantFloatInfo
  | constantLongInfo
  | constantDoubleInfo
  | constantNameAndTypeInfo
  | constantUtf8Info
  | constantMethodHandleInfo
  | constantMethodTypeInfo
  | constantInvokeDynamicInfo
  | emptyInfo
#
# Note: a single byte is endianness independant, this is why it is ok
# to write it in the \x{} form here
#
constantClassInfo              ::= [\x{07}] u2                   action =>  _constantClassInfo
constantFieldrefInfo           ::= [\x{09}] u2 u2                action =>  _constantFieldrefInfo
constantMethodrefInfo          ::= [\x{0a}] u2 u2                action =>  _constantMethodrefInfo
constantInterfaceMethodrefInfo ::= [\x{0b}] u2 u2                action =>  _constantInterfaceMethodrefInfo
constantStringInfo             ::= [\x{08}] u2                   action =>  _constantStringInfo
constantIntegerInfo            ::= [\x{03}] integerBytes         action =>  _constantIntegerInfo
constantFloatInfo              ::= [\x{04}] floatBytes           action =>  _constantFloatInfo
constantLongInfo               ::= [\x{05}] longBytes            action =>  _constantLongInfo
constantDoubleInfo             ::= [\x{06}] doubleBytes          action =>  _constantDoubleInfo
constantNameAndTypeInfo        ::= [\x{0c}] u2 u2                action =>  _constantNameAndTypeInfo
constantUtf8Info               ::= [\x{01}] utf8Length utf8Bytes action =>  _constantUtf8Info
constantMethodHandleInfo       ::= [\x{0f}] u1 u2                action =>  _constantMethodHandleInfo
constantMethodTypeInfo         ::= [\x{10}] u2                   action =>  _constantMethodType
constantInvokeDynamicInfo      ::= [\x{12}] u2 u2                action =>  _constantInvokeDynamic

integerBytes               ::= U4      action => integer          # U4 and not u4
floatBytes                 ::= U4      action => float            # U4 and not u4
longBytes                  ::= U4 U4   action => long             # U4 and not u4
doubleBytes                ::= U4 U4   action => double           # U4 and not u4
utf8Length                 ::= u2
utf8Bytes                  ::= MANAGED action => utf8             # MANAGED and not managed
emptyInfo                  ::= managed

__[ fieldName ]__
:default ::= action => ::first
lexeme default = latm => 1

# fieldName is equivalent to an unqualified name.
# An unqualified name must contain at least one Unicode code point and must not contain any of the ASCII characters . ; [ /
#
UnqualifiedName ::= UNQUALIFIEDNAME
UNQUALIFIEDNAME   ~ [^.;[/]+

__[ methodName ]__
:default ::= action => ::first
lexeme default = latm => 1

#
# UnqualifiedName, plus:
# With the exception of the special method names <init> and <clinit>, must not contain the ASCII characters < or > (that is, left angle bracket or right angle bracket).
#
MethodName ::= '<init>' | '<clinit>' | METHODNAME
METHODNAME   ~ [^.;[/<>]+

__[ fieldDescriptor ]__
:default ::= action => ::first
lexeme default = latm => 1

FieldDescriptor  ::= FieldType
FieldType        ::= BaseType
                   | ObjectType
                   | ArrayType
BaseType         ::= [BCDFIJSZ]                                                  action => MarpaX::Java::ClassFile::ConstantPoolArray::_BaseType
ObjectType       ::= ('L') ClassName (';')                                       action => MarpaX::Java::ClassFile::ConstantPoolArray::_ObjectType
ArrayType        ::= ('[') ComponentType                                         action => MarpaX::Java::ClassFile::ConstantPoolArray::_ArrayType
ComponentType    ::= FieldType

ClassName        ::= UnqualifiedName+ separator => FORWARDSLASH proper => 1      action => MarpaX::Java::ClassFile::ConstantPoolArray::_ClassName

UnqualifiedName ::= UNQUALIFIEDNAME
UNQUALIFIEDNAME   ~ [^.;[/]+
FORWARDSLASH      ~ [/]

__[ methodDescriptor ]__
:default ::= action => ::first
lexeme default = latm => 1

MethodDescriptor     ::= ('(') ParameterDescriptors (')') ReturnDescriptor       action => MarpaX::Java::ClassFile::ConstantPoolArray::_MethodDescriptor
ParameterDescriptors ::= ParameterDescriptor*                                    action => [values]
ParameterDescriptor  ::= FieldType
ReturnDescriptor     ::= FieldType
                       | VoidDescriptor
VoidDescriptor       ::= 'V'                                                     action => MarpaX::Java::ClassFile::ConstantPoolArray::_VoidDescriptor
FieldType            ::= BaseType
                       | ObjectType
                       | ArrayType
BaseType             ::= [BCDFIJSZ]                                              action => MarpaX::Java::ClassFile::ConstantPoolArray::_BaseType
ObjectType           ::= ('L') ClassName (';')                                   action => MarpaX::Java::ClassFile::ConstantPoolArray::_ObjectType
ArrayType            ::= ('[') ComponentType                                     action => MarpaX::Java::ClassFile::ConstantPoolArray::_ArrayType
ComponentType        ::= FieldType

ClassName            ::= UnqualifiedName+ separator => FORWARDSLASH proper => 1  action => MarpaX::Java::ClassFile::ConstantPoolArray::_ClassName

UnqualifiedName      ::= UNQUALIFIEDNAME
UNQUALIFIEDNAME        ~ [^.;[/]+
FORWARDSLASH           ~ [/]
