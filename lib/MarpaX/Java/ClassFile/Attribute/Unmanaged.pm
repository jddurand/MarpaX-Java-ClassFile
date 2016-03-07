use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Attribute::Unmanaged;

# ABSTRACT: Java .class's unmanaged attribute parsing

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
my %_CALLBACKS = ('unmanaged$'           => \&_unmanagedCallback,
                  'attributeLength$'           => \&_attributeLengthCallback);

has attribute_name_index => ( is => 'rwp', isa => PositiveInt );
has attribute_length     => ( is => 'rwp', isa => PositiveOrZeroInt );
has info                 => ( is => 'rwp', isa => Bytes );

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

extends 'MarpaX::Java::ClassFile::Attribute';

# ---------------
# Event callbacks
# ---------------
sub _unmanagedCallback {
  my ($self) = @_;
  $self->nbDone($self->nbDone + 1);
  $self->debugf('Completed');
  $self->max($self->pos) if ($self->nbDone >= $self->size);
}

sub _attributeLengthCallback {
  my ($self) = @_;

  my $attributeLength = $self->literalU4;
  my $info            = $attributeLength ? substr(${$self->inputRef}, $self->pos, $attributeLength) : undef;
  $self->lexeme_read('MANAGED', $attributeLength, $info);  # Note: this lexeme_read() handles case of length 0
}

# --------------------
# Our grammar actions
# --------------------
sub _unmanaged {
  my ($self, $attributeNameIndex, $attributeLength, $info) = @_;

  $self->_set_attribute_name_index($attributeNameIndex);
  $self->_set_attribute_length($attributeLength);
  $self->_set_info($info);

  [ $self ]
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'unmanaged$' = completed unmanaged
event 'attributeLength$' = completed attributeLength

unmanaged ::=
  attributeNameIndex
  attributeLength
  info                    action => _unmanaged

attributeNameIndex   ::= u2
attributeLength      ::= u4
info                 ::= managed
