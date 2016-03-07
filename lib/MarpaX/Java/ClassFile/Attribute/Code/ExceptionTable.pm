use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Attribute::Code::ExceptionTable;

# ABSTRACT: Java .class's Code exception table attribute parsing

# VERSION

# AUTHORITY

use Moo;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use Types::Common::Numeric qw/PositiveInt/;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ();

has start_pc   => ( is => 'rwp', isa => PositiveInt );
has end_pc     => ( is => 'rwp', isa => PositiveInt );
has handler_pc => ( is => 'rwp', isa => PositiveInt );
has catch_type => ( is => 'rwp', isa => PositiveInt );

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# --------------------
# Our grammar actions
# --------------------
sub _exceptionTable {
  my ($self, $startPc, $endPc, $handlerPc, $catchType) = @_;

  $self->_set_start_pc($startPc);
  $self->_set_end_pc($endPc);
  $self->_set_handler_pc($handlerPc);
  $self->_set_catch_type($catchType);

  $self
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first

exceptionTable ::=
  startPc
  endPc
  handlerPc
  catchType          action => _exceptionTable

startPc   ::= u2
endPc     ::= u2
handlerPc ::= u2
catchType ::= u2
