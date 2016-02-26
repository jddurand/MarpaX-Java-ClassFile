use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool;
use Moo;

use Data::Section -setup;
use Marpa::R2;
use Types::Standard -all;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my %_CALLBACKS = ('length$' => \&_length);

has grammar   => (is => 'ro', isa => InstanceOf['Marpa::R2::Scanless::G'], lazy => 1, builder => 1);
has callbacks => (is => 'ro', isa => HashRef[CodeRef], default => sub { \%_CALLBACKS });

sub _build_grammar {
  my ($self) = @_;

  Marpa::R2::Scanless::G->new({bless_package => 'ConstantPool', source => \__PACKAGE__->bnf($_data)})
}

sub _length {
  my ($self, $r) = @_;

  my $length = $self->literalU2($r, 'length');
  $self->lexeme_read($r, 'MANAGED', $self->pos, $length, substr($self->input, $self->pos, $length)) if ($length)
}

sub _constantClassInfo {
  my ($self, $nameIndex) = @_; bless {name_index => $nameIndex}, 'CONSTANT_Class_info'
}

sub _constantFieldrefInfo {
  my ($self, $classIndex, $nameAndTypeIndex) = @_; bless {class_index => $classIndex, name_and_type_index => $nameAndTypeIndex}, 'CONSTANT_Fieldref_info'
}

sub _constantMethodrefInfo {
  my ($self, $classIndex, $nameAndTypeIndex) = @_; bless {class_index => $classIndex, name_and_type_index => $nameAndTypeIndex}, 'CONSTANT_Methodref_info'
}

sub _constantInterfaceMethodrefInfo {
  my ($self, $classIndex, $nameAndTypeIndex) = @_; bless {class_index => $classIndex, name_and_type_index => $nameAndTypeIndex}, 'CONSTANT_InterfaceMethodref_info'
}

sub _constantStringInfo {
  my ($self, $stringIndex) = @_;  bless {string_index => $stringIndex}, 'CONSTANT_String_info'
}

sub _constantIntegerInfo {
  my ($self, $integer) = @_;  bless {value => $integer}, 'CONSTANT_Integer_info'
}

sub _constantFloatInfo {
  my ($self, $float) = @_;  bless {value => $float}, 'CONSTANT_Float_info'
}

sub _constantLongInfo {
  my ($self, $long) = @_;  bless {value => $long}, 'CONSTANT_Long_info'
}

sub _constantUtf8Info_01 {
  my ($self, $length, $utf8) = @_; bless {length => $length, string => $utf8}, 'CONSTANT_Utf8_info'
}

sub _constantUtf8Info_02 {
  my ($self, $length, $utf8) = @_; bless {length => $length, string => undef}, 'CONSTANT_Utf8_info'
}

with qw/MarpaX::Java::ClassFile::BNF
        MarpaX::Java::ClassFile::Common/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first

event 'length$' = completed length
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
constantClassInfo              ::= ([\x{07}]) nameIndex                                 action => _constantClassInfo
constantFieldrefInfo           ::= ([\x{09}]) classIndex               nameAndTypeIndex action => _constantFieldrefInfo
constantMethodrefInfo          ::= ([\x{0a}]) classIndex               nameAndTypeIndex action => _constantMethodrefInfo
constantInterfaceMethodrefInfo ::= ([\x{0b}]) classIndex               nameAndTypeIndex action => _constantInterfaceMethodrefInfo
constantStringInfo             ::= ([\x{08}]) stringIndex                               action => _constantStringInfo
constantIntegerInfo            ::= ([\x{03}]) integerBytes                              action => _constantIntegerInfo
constantFloatInfo              ::= ([\x{04}]) floatBytes                                action => _constantFloatInfo
constantLongInfo               ::= ([\x{05}]) longBytes                                 action => _constantLongInfo
constantDoubleInfo             ::= ([\x{06}]) doubleBytes
constantNameAndTypeInfo        ::= ([\x{0c}]) nameIndex                descriptorIndex
constantUtf8Info               ::= ([\x{01}]) length                   utf8Bytes        action => _constantUtf8Info_01
                                 | ([\x{01}]) length                                    action => _constantUtf8Info_02
constantMethodHandleInfo       ::= ([\x{0f}]) referenceKind            referenceIndex
constantMethodTypeInfo         ::= ([\x{10}]) descriptorIndex
constantInvokeDynamicInfo      ::= ([\x{12}]) bootstrapMethodAttrIndex nameAndTypeIndex

bootstrapMethodAttrIndex   ::= u2
longBytes                  ::= u4 u4   action => long
doubleBytes                ::= u4 u4   # action => double
descriptorIndex            ::= u2
nameAndTypeIndex           ::= u2
nameIndex                  ::= u2
length                     ::= u2
referenceKind              ::= u1
referenceIndex             ::= u2
classIndex                 ::= u2
stringIndex                ::= u2
integerBytes               ::= u4      action => integer
floatBytes                 ::= u4      action => float
utf8Bytes                  ::= managed action => utf8
