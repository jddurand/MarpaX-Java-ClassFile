use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::TableArray;
use Moo;

# ABSTRACT: Parsing an array of table

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/bnf/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::Table;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted" => sub { $_[0]->exhausted },
                        'table$'     => sub { $_[0]->inc_nbDone }
                       }
}

# ---------------
# Grammar actions
# ---------------
sub _table {
  # my ($self, $start_pc, $length, $index) = @_;

  MarpaX::Java::ClassFile::Struct::Table->new(
                                              start_pc => $_[1],
                                              length   => $_[2],
                                              index    => $_[3]
                                             )
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default   ::= action => [values]
event 'table$' = completed table
tableArray ::= table*
table      ::= start_pc length index action => _table
start_pc   ::= U2                    action => u2
length     ::= U2                    action => u2
index      ::= U2                    action => u2
