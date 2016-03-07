use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Attribute::ConstantValue;

# ABSTRACT: Java .class's ConstantValue attribute parsing

# VERSION

# AUTHORITY

use Moo;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use Types::Common::Numeric qw/PositiveInt PositiveOrZeroInt/;
use Types::Encodings qw/Bytes/;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('constantValue' => \&_constantValueCallback);

has attribute_name_index => ( is => 'rwp', isa => PositiveInt );
has attribute_length     => ( is => 'rwp', isa => PositiveOrZeroInt );
has constant_value_index => ( is => 'rwp', isa => PositiveInt );

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

extends 'MarpaX::Java::ClassFile::Attribute';

# ---------------
# Event callbacks
# ---------------
sub _constantValueCallback {
  my ($self) = @_;

  $self->nbDone($self->nbDone + 1);
  $self->max($self->pos) if ($self->nbDone >= $self->size); # Set the max position so that parsing end
}

# --------------------
# Our grammar actions
# --------------------
sub _constantValue {
  my ($self, $attributeNameIndex, $attributeLength, $constantValueIndex) = @_;

  $self->_set_attribute_name_index($attributeNameIndex);
  $self->_set_attribute_length($attributeLength);
  $self->_set_constantvalue_index($constantValueIndex);

  [ $self ]
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'constantValue$' = completed constantValue

constantValue ::=
  attribute_name_index
  attribute_length
  constantvalue_index       action => _constantValue

attribute_name_index ::= u2
attribute_length     ::= u4
constantvalue_index  ::= u2
