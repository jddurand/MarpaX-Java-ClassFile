use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool;
use Moo;

use Marpa::R2;
use Types::Standard -all;

extends 'MarpaX::Java::ClassFile::BNF';

my $G         = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf(do { local $/; <DATA> })});
my %CALLBACKS = ('constant_pool_count$' => \&_constant_pool_count);

has grammar   => (is => 'ro', isa => InstanceOf['Marpa::R2::Scanless::G'], default => sub { $G });
has callbacks => (is => 'ro', isa => HashRef[CodeRef], default => sub { \%CALLBACKS });

sub _constant_pool_count {
  my ($self, $r, $pos, $max, $reloopRef) = @_;

  my $count = $self->u1($r, $pos, $max, 'constant_pool_count');
  my $imax = $count - 1;
  my @managed = ();
  my $i = 0;
  while (++$i <= $imax) {
    push(@managed, MarpaX::Java::ClassFile::ConstantPool->new($self->input)->parse);
    if ($managed[-1]->{tag} == 0000000000) {
      # JDD
    }
  }

}

with 'MarpaX::Java::ClassFile::Common';

1;

__DATA__
cp_info ::=
    CONSTANT_Class_info
  | CONSTANT_Fieldref_info
  | CONSTANT_Methodref_info
  | CONSTANT_InterfaceMethodref_info
  | CONSTANT_String_info
  | CONSTANT_Integer_info
  | CONSTANT_Float_info
  | CONSTANT_Long_info
  | CONSTANT_Double_info
  | CONSTANT_NameAndType_info
  | CONSTANT_Utf8_info
  | CONSTANT_MethodHandle_info
  | CONSTANT_MethodType_info
  | CONSTANT_InvokeDynamic_info

#
# Note: a single byte is endianness independant, this is why it is ok
# to write it in the \x{} form here
#
CONSTANT_Class_info              ::= ([\x{07}]) name_index
CONSTANT_Fieldref_info           ::= ([\x{09}]) class_index                 name_and_type_index
CONSTANT_Methodref_info          ::= ([\x{0a}]) class_index                 name_and_type_index
CONSTANT_InterfaceMethodref_info ::= ([\x{0b}]) class_index                 name_and_type_index
CONSTANT_String_info             ::= ([\x{08}]) string_index
CONSTANT_Integer_info            ::= ([\x{03}]) bytes
CONSTANT_Float_info              ::= ([\x{04}]) bytes
CONSTANT_Long_info               ::= ([\x{05}]) high_bytes                  low_bytes
CONSTANT_Double_info             ::= ([\x{06}]) high_bytes                  low_bytes
CONSTANT_NameAndType_info        ::= ([\x{0c}]) name_index                  descriptor_index
CONSTANT_Utf8_info               ::= ([\x{01}]) length                      bytes
CONSTANT_MethodHandle_info       ::= ([\x{0f}]) reference_kind              reference_index
CONSTANT_MethodType_info         ::= ([\x{10}]) descriptor_index
CONSTANT_InvokeDynamic_info      ::= ([\x{12}]) bootstrap_method_attr_index name_and_type_index

bootstrap_method_attr_index ::= u2      action => ::first
low_bytes                   ::= u4      action => ::first
high_bytes                  ::= u4      action => ::first
descriptor_index            ::= u2      action => ::first
name_and_type_index         ::= u2      action => ::first
name_index                  ::= u2      action => ::first
length                      ::= u2      action => ::first
reference_kind              ::= u1      action => ::first
reference_index             ::= u2      action => ::first
class_index                 ::= u2      action => ::first
string_index                ::= u2      action => ::first
bytes                       ::= managed action => ::first
