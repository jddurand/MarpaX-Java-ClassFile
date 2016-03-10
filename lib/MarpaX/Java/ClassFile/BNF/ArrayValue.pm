use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ArrayValue;
use Moo;

# ABSTRACT: Parsing of an array value

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ArrayValue;
use MarpaX::Java::ClassFile::BNF::ElementValueArray;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted" => sub { $_[0]->exhausted },
          'num_values$' => sub { $_[0]->inner('ElementValueArray', size => $_[0]->literalU2('num_values')) }
         }
}

sub _ArrayValue {
  # my ($self, $num_values, $values) = @_;

  MarpaX::Java::ClassFile::Struct::ArrayValue->new(
                                                   num_values => $_[1],
                                                   values     => $_[2]
                                                  )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'num_values$' = completed num_values

ArrayValue ::= num_values values action => _ArrayValue
num_values ::= U2                action => u2
values     ::= MANAGED           action => ::first
