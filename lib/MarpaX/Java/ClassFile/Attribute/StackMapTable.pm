use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Attribute::StackMapTable;

# ABSTRACT: Java .class's StackMapTable attribute parsing

# VERSION

# AUTHORITY

use Moo;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
# use MarpaX::Java::ClassFile::Attribute::StackMapTable::Frame;
use Types::Common::Numeric qw/PositiveInt PositiveOrZeroInt/;
use Types::Encodings qw/Bytes/;
use Types::Standard qw/ArrayRef InstanceOf/;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('StackMapTable$'   => \&_StackMapTableCallback,
                  'numberOfEntries$' => \&_numberOfEntriesCallback
                 );

has attribute_name_index   => ( is => 'rwp', isa => PositiveInt );
has attribute_length       => ( is => 'rwp', isa => PositiveOrZeroInt );
has number_of_entries      => ( is => 'rwp', isa => PositiveOrZeroInt );
has entries                => ( is => 'rwp', isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Attribute::StackMapTable::Frame']] );

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

extends 'MarpaX::Java::ClassFile::Attribute';

# ---------------
# Event callbacks
# ---------------
sub _StackMapTableCallback {
  my ($self) = @_;

  $self->nbDone($self->nbDone + 1);
  $self->max($self->pos) if ($self->nbDone >= $self->size); # Set the max position so that parsing end
}

sub _numberOfEntriesCallback {
  my ($self) = @_;

  $self->executeInnerGrammar(
                             'MarpaX::Java::ClassFile::Attribute::StackMapTable::Frame',
                             'array',
                             classFile => $self->classFile,
                             size => $self->literalU2)
}

# --------------------
# Our grammar actions
# --------------------
sub _StackMapTable {
  my ($self, $attributeNameIndex, $attributeLength, $numberOfEntries, $entries) = @_;

  $self->_set_attribute_name_index($attributeNameIndex);
  $self->_set_attribute_length($attributeLength);
  $self->_set_number_of_entries($numberOfEntries);
  $self->_set_entries($entries);

  [ $self ]
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'StackMapTable$'   = completed StackMapTable
event 'numberOfEntries$' = completed numberOfEntries

StackMapTable ::=
  attributeNameIndex
  attributeLength
  numberOfEntries
  entries                          action => _StackMapTable

attributeNameIndex   ::= u2
attributeLength      ::= u4
numberOfEntries      ::= u2
entries              ::= managed
