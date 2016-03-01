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

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ------------
# Our thingies
# ------------
has classFiles      => (is => 'ro', isa => HashRef[InstanceOf['MarpaX::Java::ClassFile']], default => sub { {} } );
has _lastTag        => (is => 'rw', isa => PositiveOrZeroInt, default => sub { 0 });  # Tag with value 0 does not exist -;
has _skipNextEntry  => (is => 'rw', isa => Bool,              default => sub { 0 });

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
sub _checkItem {
  my ($self, $cpInfoArrayRef, $itemIndex, %constraint)  = @_;

  #
  # minIndex constraint ?
  #
  $self->fatalf('Item index %d must be >= %d', $itemIndex, $constraint{minIndex})
    if (defined($constraint{minIndex}) && $itemIndex < $constraint{minIndex});
  #
  # maxIndex constraint ?
  #
  $self->fatalf('Item index %d must be <= %d', $itemIndex, $constraint{maxIndex})
    if (defined($constraint{maxIndex}) && $itemIndex > $constraint{maxIndex});

  my $item = $cpInfoArrayRef->[$itemIndex - 1];
  return unless (defined($item));
  #
  # Blessed constraint ?
  #
  my $blessed = blessed($item) // '';
  $self->fatalf('Item %s is not blesssed to %s', $item)
    if (defined($constraint{blessed}) && $constraint{blessed} ne $blessed);

  if ($blessed eq 'CONSTANT_Class_info') {
    #
    # The value of the name_index item must be a valid index into the constant_pool table.
    # The constant_pool entry at that index must be a CONSTANT_Utf8_info structure.
    #
    $self->_checkItem($cpInfoArrayRef, $item->{name_index}, %constraint, blessed => 'CONSTANT_Utf8_info')
  }
  elsif ($blessed eq 'CONSTANT_Fieldref_info'           ||
         $blessed eq 'CONSTANT_Methodref_info'          ||
         $blessed eq 'CONSTANT_InterfaceMethodref_info') {
    #
    # The value of the class_index item must be a valid index into the constant_pool table.
    # The constant_pool entry at that index must be a CONSTANT_Class_info structure.
    #
    my $classInfo = $self->_checkItem($cpInfoArrayRef, $item->{class_index}, %constraint, blessed => 'CONSTANT_Class_info');
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
      my $isInterface = grep { $_ eq 'interface' } @{$accessFlags};
      my $isClass     = ! $isInterface;
      if ($blessed eq 'CONSTANT_Methodref_info') {
        $self->fatalf('%s (constant pool item No %d) references a ClassFile named %s that is not a class, but: %s',
                      blessed($item),
                      $itemIndex,
                      $className,
                      $accessFlags) unless ($isClass);
      } elsif ($blessed eq 'CONSTANT_InterfaceMethodref_info') {
        $self->fatalf('%s (constant pool item No %d) references a ClassFile named %s that is not an interface, but: %s',
                      blessed($item),
                      $itemIndex,
                      $className,
                      $accessFlags) unless ($isInterface);
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
    $self->_checkItem($cpInfoArrayRef, $item->{name_and_type_index}, %constraint, blessed => 'CONSTANT_NameAndType_info');
    #
    # In a CONSTANT_Fieldref_info, the indicated descriptor must be a field descriptor.
    # Otherwise, the indicated descriptor must be a method descriptor.
    #
    # If the name of the method of a CONSTANT_Methodref_info structure begins with a '<' ('\u003c'),
    # then the name must be the special name <init>, representing an instance initialization method.
    # The return type of such a method must be void.
    #
  }

  $item
}

sub _cpInfoArray {
  my ($self, @cpInfo) = @_;

  my ($minIndex, $maxIndex) = (1, scalar(@cpInfo));
  my @commonArgs = (\@cpInfo, 1, scalar(@cpInfo));

  [ map { $self->_checkItem(\@cpInfo, $_, minIndex => $minIndex, maxIndex => $maxIndex) } ($minIndex..$maxIndex) ]
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
