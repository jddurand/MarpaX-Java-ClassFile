use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::FullFrame;
use Moo;

# ABSTRACT: Parsing of a full_frame

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::FullFrame;
use MarpaX::Java::ClassFile::BNF::VerificationTypeInfoArray;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"             => sub { $_[0]->exhausted },
                        'number_of_locals$'      => sub { $_[0]->inner('VerificationTypeInfoArray', size => $_[0]->literalU2('number_of_locals')) },
                        'number_of_stack_items$' => sub { $_[0]->inner('VerificationTypeInfoArray', size => $_[0]->literalU2('number_of_stack_items')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _full_frame {
  # my ($self, $frame_type, $offset_delta, $number_of_locals, $locals, $number_of_stack_items, $stack) = @_;

  MarpaX::Java::ClassFile::Struct::FullFrame->new(
                                                  frame_type            => $_[1],
                                                  offset_delta          => $_[2],
                                                  number_of_locals      => $_[3],
                                                  locals                => $_[4],
                                                  number_of_stack_items => $_[5],
                                                  stack                 => $_[6]
                                                 )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'number_of_locals$'      = completed number_of_locals
event 'number_of_stack_items$' = completed number_of_stack_items
full_frame            ::= frame_type offset_delta number_of_locals locals number_of_stack_items stack action => _full_frame
frame_type            ::= U1                                                                          action => u1
offset_delta          ::= U2                                                                          action => u2
number_of_locals      ::= U2                                                                          action => u2
locals                ::= MANAGED                                                                     action => ::first
number_of_stack_items ::= U2                                                                          action => u2
stack                 ::= MANAGED                                                                     action => ::first
