use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::LocalVariableArray;
use Moo;

# ABSTRACT: Parsing an array of local variable

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::LocalVariable;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"     => sub { $_[0]->exhausted  },
          'local_variable$' => sub { $_[0]->inc_nbDone }
         }
}

sub _local_variable {
  # my ($self, $start_pc, $length, $name_index, $descriptor_index, $index) = @_;

  MarpaX::Java::ClassFile::Struct::LocalVariable->new(
                                                      _constant_pool   => $_[0]->constant_pool,
                                                      start_pc         => $_[1],
                                                      length           => $_[2],
                                                      name_index       => $_[3],
                                                      descriptor_index => $_[4],
                                                      index            => $_[5]
                                                     )
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'local_variable$' = completed local_variable

localVariableArray ::= local_variable*
local_variable     ::= start_pc length name_index descriptor_index index action => _local_variable
start_pc           ::= U2                                                action => u2
length             ::= U2                                                action => u2
name_index         ::= U2                                                action => u2
descriptor_index   ::= U2                                                action => u2
index              ::= U2                                                action => u2
