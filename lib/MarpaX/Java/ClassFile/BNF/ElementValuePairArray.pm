use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ElementValuePairArray;
use Moo;

# ABSTRACT: Parsing an array of element value pair

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ElementValuePair;
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
           "'exhausted"         => sub { $_[0]->exhausted },
          'element_value_pair$' => sub { $_[0]->inc_nbDone },
          'element_name_index$' => sub { $_[0]->inner('ElementValue') }
         }
}

sub _element_value_pair {
  # my ($self, $element_name_index, $value) = @_;

  MarpaX::Java::ClassFile::Struct::ElementValuePair->new(
                                                         element_name_index  => $_[1],
                                                         value               => $_[2]
                                                        )
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'element_value_pair$' = completed element_value_pair
event 'element_name_index$' = completed element_name_index

elementValuePairArray ::= element_value_pair*

element_value_pair ::= element_name_index value action => _element_value_pair
element_name_index ::= U2                       action => u2
value              ::= MANAGED                  action => ::first
