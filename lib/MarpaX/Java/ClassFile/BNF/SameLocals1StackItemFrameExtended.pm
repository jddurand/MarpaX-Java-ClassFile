use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SameLocals1StackItemFrameExtended;
use Moo;

# ABSTRACT: Parsing of a same_locals_1_stack_item_frame_extended

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::SameLocals1StackItemFrameExtended;
use MarpaX::Java::ClassFile::BNF::VerificationTypeInfoArray;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"    => sub { $_[0]->exhausted },
                        'offset_delta$' => sub { $_[0]->inner('VerificationTypeInfoArray', size => 1) },
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _same_locals_1_stack_item_frame_extended {
  # my ($self, $frame_type, $offset_delta, $stack) = @_;

  MarpaX::Java::ClassFile::Struct::SameLocals1StackItemFrameExtended->new(
                                                                          frame_type   => $_[1],
                                                                          offset_delta => $_[2],
                                                                          stack        => $_[3]
                                                                         )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'offset_delta$' = completed offset_delta
same_locals_1_stack_item_frame ::= frame_type offset_delta stack action => _same_locals_1_stack_item_frame_extended
frame_type                     ::= U1                            action => u1
offset_delta                   ::= U2                            action => u2
stack                          ::= MANAGED                       action => ::first
