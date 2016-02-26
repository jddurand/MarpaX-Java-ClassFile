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

with qw/MarpaX::Java::ClassFile::BNF
        MarpaX::Java::ClassFile::Common/;

1;

__DATA__
__[ bnf ]__
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
constantClassInfo              ::= ([\x{07}]) nameIndex
constantFieldrefInfo           ::= ([\x{09}]) classIndex               nameAndTypeIndex
constantMethodrefInfo          ::= ([\x{0a}]) classIndex               nameAndTypeIndex
constantInterfaceMethodrefInfo ::= ([\x{0b}]) classIndex               nameAndTypeIndex
constantStringInfo             ::= ([\x{08}]) stringIndex
constantIntegerInfo            ::= ([\x{03}]) bytes
constantFloatInfo              ::= ([\x{04}]) bytes
constantLongInfo               ::= ([\x{05}]) highBytes                lowBytes
constantDoubleInfo             ::= ([\x{06}]) highBytes                lowBytes
constantNameAndTypeInfo        ::= ([\x{0c}]) nameIndex                descriptorIndex
constantUtf8Info               ::= ([\x{01}]) length                   utf8 action => asHashRef
                                 | ([\x{01}]) length
constantMethodHandleInfo       ::= ([\x{0f}]) referenceKind            referenceIndex
constantMethodTypeInfo         ::= ([\x{10}]) descriptorIndex
constantInvokeDynamicInfo      ::= ([\x{12}]) bootstrapMethodAttrIndex nameAndTypeIndex

bootstrapMethodAttrIndex   ::= u2      action => first
lowBytes                   ::= u4      action => first
highBytes                  ::= u4      action => first
descriptorIndex            ::= u2      action => first
nameAndTypeIndex           ::= u2      action => first
nameIndex                  ::= u2      action => first
length                     ::= u2      action => first
referenceKind              ::= u1      action => first
referenceIndex             ::= u2      action => first
classIndex                 ::= u2      action => first
stringIndex                ::= u2      action => first
bytes                      ::= u4      action => first
utf8                       ::= managed action => first
