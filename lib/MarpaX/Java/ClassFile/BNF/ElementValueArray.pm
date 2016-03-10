use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ElementValueArray;
use Moo;

# ABSTRACT: Parsing an array of elementValue

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::BNF::ElementValue;
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
          'elementValueArray$' => sub { $_[0]->inc_nbDone },
          '^elementValue'      => sub { $_[0]->inner('ElementValue') if ($_[0]->nbDone < $_[0]->size) }
         }
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'elementValueArray$' = completed elementValueArray
event '^elementValue' = predicted elementValue

elementValueArray ::= elementValue*
elementValue      ::= MANAGED action => ::first
