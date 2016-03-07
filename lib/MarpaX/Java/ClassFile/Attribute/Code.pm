use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Attribute::Code;

# ABSTRACT: Java .class's Code attribute parsing

# VERSION

# AUTHORITY

use Moo;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use MarpaX::Java::ClassFile::AttributesArray;
use MarpaX::Java::ClassFile::Attribute::Code::ExceptionTable;
use Types::Common::Numeric qw/PositiveInt PositiveOrZeroInt/;
use Types::Encodings qw/Bytes/;
use Types::Standard qw/ArrayRef InstanceOf/;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('Code$'                 => \&_CodeCallback,
                  'codeLength$'           => \&_codeLengthCallback,
                  'exceptionTableLength$' => \&_exceptionTableLengthCallback,
                  'attributesCount$'      => \&_attributesCountCallback
                 );

has attribute_name_index   => ( is => 'rwp', isa => PositiveInt );
has attribute_length       => ( is => 'rwp', isa => PositiveOrZeroInt );
has max_stack              => ( is => 'rwp', isa => PositiveOrZeroInt );
has max_locals             => ( is => 'rwp', isa => PositiveOrZeroInt );
has code_length            => ( is => 'rwp', isa => PositiveOrZeroInt );
has code                   => ( is => 'rwp', isa => Bytes );
has exception_table_length => ( is => 'rwp', isa => PositiveOrZeroInt );
has exception_table        => ( is => 'rwp', isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Attribute::Code::ExceptionTable']] );
has attributes_count       => ( is => 'rwp', isa => PositiveOrZeroInt );
has attributes             => ( is => 'rwp', isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Attribute']] );

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

extends 'MarpaX::Java::ClassFile::Attribute';

# ---------------
# Event callbacks
# ---------------
sub _CodeCallback {
  my ($self) = @_;

  $self->nbDone($self->nbDone + 1);
  $self->max($self->pos) if ($self->nbDone >= $self->size); # Set the max position so that parsing end
}

sub _codeLengthCallback {
  my ($self) = @_;

  my $codeLength = $self->literalU4;
  my $code       = $codeLength ? substr(${$self->inputRef}, $self->pos, $codeLength) : undef;
  $self->lexeme_read('MANAGED', $codeLength, $code);  # Note: this lexeme_read() handles case of length 0
}

sub _exceptionTableLengthCallback {
  my ($self) = @_;

  $self->executeInnerGrammar(
                             'MarpaX::Java::ClassFile::Attribute::Code::ExceptionTable',
                             'array',
                             classFile => $self->classFile,
                             size => $self->literalU2)
}

sub _attributesCountCallback {
  my ($self) = @_;

  $self->executeInnerGrammar(
                             'MarpaX::Java::ClassFile::AttributesArray',
                             'array',
                             classFile => $self->classFile,
                             size => $self->literalU2)
}

# --------------------
# Our grammar actions
# --------------------
sub _Code {
  my ($self, $attributeNameIndex, $attributeLength, $maxStack, $maxLocals, $codeLength, $code, $exceptionTableLength, $exceptionTable, $attributesCount, $attributes) = @_;

  $self->_set_attribute_name_index($attributeNameIndex);
  $self->_set_attribute_length($attributeLength);
  $self->_set_max_stack($maxStack);
  $self->_set_max_locals($maxLocals);
  $self->_set_code_length($codeLength);
  $self->_set_code($code);
  $self->_set_exception_table_length($exceptionTableLength);
  $self->_set_exception_table($exceptionTable);
  $self->_set_attributes_count($attributesCount);
  $self->_set_attributes($attributes);

  [ $self ]
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'Code$' = completed Code
event 'codeLength$' = completed codeLength
event 'exceptionTableLength$' = completed exceptionTableLength
event 'attributesCount$' = completed attributesCount

Code ::=
  attributeNameIndex
  attributeLength
  maxStack
  maxLocals
  codeLength
  code
  exceptionTableLength
  exceptionTable
  attributesCount
  attributes                          action => _Code

attributeNameIndex   ::= u2
attributeLength      ::= u4
maxStack             ::= u2
maxLocals            ::= u2
codeLength           ::= u4
code                 ::= managed
exceptionTableLength ::= u2
exceptionTable       ::= managed
attributesCount      ::= u2
attributes           ::= managed
