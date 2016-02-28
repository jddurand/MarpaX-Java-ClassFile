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
use Types::Common::Numeric -all;
use Types::Standard -all;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('utf8Length$'         => \&_utf8LengthCallback,
                  'constantLongInfo$'   => \&_constantLongInfoCallback,
                  'constantDoubleInfo$' => \&_constantDoubleInfoCallback,
                  'cpInfo$'             => \&_cpInfoCallback,
                  '^indice'             => \&_indiceCallback,
                 );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ------------
# Our thingies
# ------------
has size            => (is => 'ro', isa => PositiveOrZeroInt, required => 1);
has _lastTag        => (is => 'rw', isa => PositiveOrZeroInt, default => sub { 0 });  # Tag with value 0 does not exist -;
has _nbDone         => (is => 'rw', isa => PositiveOrZeroInt, default => sub { 0 });
has _skipNextEntry  => (is => 'rw', isa => Bool,              default => sub { 0 });

sub BUILD {
  my ($self) = @_;
  $self->debugf('Starting');
  $self->ast([]) if (! $self->size)
}

# ---------------
# Callback callbacks
# ---------------
sub _utf8LengthCallback {
  my ($self, $r) = @_;

  my $utf8Length = $self->literalU2($r);
  my $utf8String = $utf8Length ? undef : substr($self->input, $self->pos, $utf8Length);
  $self->tracef('Modified UTF-8: %s', $utf8String);
  $self->lexeme_read($r, 'MANAGED', $utf8Length, $utf8String);  # Note: this lexeme_read() handles case of length 0
}

sub _constantLongInfoCallback {
  my ($self, $r) = @_;
  $self->_skipNextEntry(1);
}

sub _constantDoubleInfoCallback {
  my ($self, $r) = @_;
  $self->_skipNextEntry(1);
}

sub _cpInfoCallback {
  my ($self, $r) = @_;
  $self->_nbDone($self->_nbDone + 1);
  if ($self->_skipNextEntry) {
    $self->debugf('Skipping next entry');
    $self->_nbDone($self->_nbDone + 1);
    $self->_skipNextEntry(0)
  }
  $self->max($self->pos) if ($self->_nbDone >= $self->size) # Set the max position so that parsing end
}

sub _indiceCallback {
  my ($self, $r) = @_;
  $self->lexeme_read($r, 'MANAGED', 0, $self->_nbDone + 1);
}

# --------------------
# Our grammar actions
# --------------------
my %_ARG2HASH =
  (
   CONSTANT_Class_info              => [qw/tag name_index indice/],
   CONSTANT_Fieldref_info           => [qw/tag class_index name_and_type_index indice/],
   CONSTANT_Methodref_info          => [qw/tag class_index name_and_type_index indice/],
   CONSTANT_InterfaceMethodref_info => [qw/tag class_index name_and_type_index indice/],
   CONSTANT_String_info             => [qw/tag string_index indice/],
   CONSTANT_Integer_info            => [qw/tag computed_value indice/],
   CONSTANT_Float_info              => [qw/tag computed_value indice/],
   CONSTANT_Long_info               => [qw/tag computed_value indice/],
   CONSTANT_Double_info             => [qw/tag computed_value indice/],
   CONSTANT_NameAndType_info        => [qw/tag name_index descriptor_index indice/],
   CONSTANT_Utf8_info               => [qw/tag length computed_value indice/],
   CONSTANT_MethodHandle_info       => [qw/tag reference_kind reference_index indice/],
   CONSTANT_MethodType_info         => [qw/tag descriptor_index indice/],
   CONSTANT_InvokeDynamic_info      => [qw/tag bootstrap_method_attr_index name_and_type_index indice/]
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

with qw/MarpaX::Java::ClassFile::Common/;

# ------------------
# Role modifications
# ------------------
around whoami => sub {
  my ($orig, $self, @args) = @_;

  my $whoami = $self->$orig(@args);
  #
  # Append the array indice, eventually
  #
  $self->_nbDone ? join('', $whoami, '[', $self->_nbDone, '/', $self->size, ']') : $whoami
};

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event '^indice'             = predicted indice
event 'cpInfo$'             = completed cpInfo
event 'utf8Length$'         = completed utf8Length
event 'constantLongInfo$'   = completed constantLongInfo
event 'constantDoubleInfo$' = completed constantDoubleInfo

cpInfoArray ::= cpInfo*       action => [values]
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
#
# Note: a single byte is endianness independant, this is why it is ok
# to write it in the \x{} form here
#
constantClassInfo              ::= [\x{07}] u2                   indice action =>  _constantClassInfo
constantFieldrefInfo           ::= [\x{09}] u2 u2                indice action =>  _constantFieldrefInfo
constantMethodrefInfo          ::= [\x{0a}] u2 u2                indice action =>  _constantMethodrefInfo
constantInterfaceMethodrefInfo ::= [\x{0b}] u2 u2                indice action =>  _constantInterfaceMethodrefInfo
constantStringInfo             ::= [\x{08}] u2                   indice action =>  _constantStringInfo
constantIntegerInfo            ::= [\x{03}] integerBytes         indice action =>  _constantIntegerInfo
constantFloatInfo              ::= [\x{04}] floatBytes           indice action =>  _constantFloatInfo
constantLongInfo               ::= [\x{05}] longBytes            indice action =>  _constantLongInfo
constantDoubleInfo             ::= [\x{06}] doubleBytes          indice action =>  _constantDoubleInfo
constantNameAndTypeInfo        ::= [\x{0c}] u2 u2                indice action =>  _constantNameAndTypeInfo
constantUtf8Info               ::= [\x{01}] utf8Length utf8Bytes indice action =>  _constantUtf8Info
constantMethodHandleInfo       ::= [\x{0f}] u1 u2                indice action =>  _constantMethodHandleInfo
constantMethodTypeInfo         ::= [\x{10}] u2                   indice action =>  _constantMethodType
constantInvokeDynamicInfo      ::= [\x{12}] u2 u2                indice action =>  _constantInvokeDynamic

indice                     ::= managed action => ::first          # Because indices may be skipped we manage ourself its value
integerBytes               ::= U4      action => integer          # U4 and not u4
floatBytes                 ::= U4      action => float            # U4 and not u4
longBytes                  ::= U4 U4   action => long             # U4 and not u4
doubleBytes                ::= U4 U4   action => double           # U4 and not u4
utf8Length                 ::= u2
utf8Bytes                  ::= managed action => utf8
