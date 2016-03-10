use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ExceptionsAttribute;
use Moo;

# ABSTRACT: Parsing of a Exceptions_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ExceptionsAttribute;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted" => sub { $_[0]->exhausted },
                        'number_of_exceptions$' => sub {
                          my $number_of_exceptions = $_[0]->literalU2('number_of_exceptions');
                          map { $_[0]->lexeme_read_u2(1) } (1..$number_of_exceptions); # Ignore events
                          $_[0]->lexeme_read_managed(0)                                # Will trigger exhaustion
                        }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _Exceptions_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $number_of_exceptions, $exception_index_table) = @_;

  MarpaX::Java::ClassFile::Struct::ExceptionsAttribute->new(
                                                            attribute_name_index  => $_[1],
                                                            attribute_length      => $_[2],
                                                            number_of_exceptions  => $_[3],
                                                            exception_index_table => $_[4],
                                                           )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'number_of_exceptions$' = completed number_of_exceptions
Exceptions_attribute ::= attribute_name_index attribute_length number_of_exceptions exception_index_table (end) action => _Exceptions_attribute
attribute_name_index    ::= U2                                                        action => u2
attribute_length        ::= U4                                                        action => u4
number_of_exceptions    ::= U2                                                        action => u2
exception_index_table   ::= exception_index                                           action => [values]
exception_index         ::= U2                                                        action => u2
end                     ::= MANAGED                                                   # Used to trigger the exhaustion event
