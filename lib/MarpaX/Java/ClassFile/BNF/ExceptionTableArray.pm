use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ExceptionTableArray;
use Moo;

# ABSTRACT: Parsing an array of exception_table

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ExceptionTable;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"      => sub { $_[0]->exhausted },
          'exception_table$' => sub { $_[0]->inc_nbDone }
         }
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

sub _exception_table {
  # my ($self, $start_pc, $end_pc, $handler_pc, $catch_type) = @_;

  MarpaX::Java::ClassFile::Struct::ExceptionTable->new(
                                                       start_pc   => $_[1],
                                                       end_pc     => $_[2],
                                                       handler_pc => $_[3],
                                                       catch_type => $_[4]
                                                      )
}

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'exception_table$' = completed exception_table

exceptionTableArray ::= exception_table*
exception_table ::= start_pc end_pc handler_pc catch_type action => _exception_table
start_pc        ::= U2                                    action => u2
end_pc          ::= U2                                    action => u2
handler_pc      ::= U2                                    action => u2
catch_type      ::= U2                                    action => u2
