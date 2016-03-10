use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::LineNumberTableArray;
use Moo;

# ABSTRACT: Parsing an array of class

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::LineNumberTable;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"        => sub { $_[0]->exhausted },
          'line_number_table$' => sub { $_[0]->inc_nbDone }
         }
}

sub _line_number_table {
  # my ($self, $start_pc, $line_number) = @_;

  MarpaX::Java::ClassFile::Struct::LineNumberTable->new(
                                                        start_pc    => $_[1],
                                                        line_number => $_[2]
                                                       )
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'line_number_table$' = completed line_number_table

lineNumberTableArray ::= line_number_table*
line_number_table    ::= start_pc line_number action => _line_number_table
start_pc             ::= U2 action => u2
line_number          ::= U2 action => u2
