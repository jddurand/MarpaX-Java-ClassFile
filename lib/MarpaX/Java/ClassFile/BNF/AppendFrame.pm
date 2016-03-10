use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::AppendFrame;
use Moo;

# ABSTRACT: Parsing of a append_frame

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::AppendFrame;
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
                        'offset_delta$' => sub { inner('VerificationTypeInfoArray', size => $_[0]->literalU2('frame_type') - 251) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _append_frame {
  # my ($self, $frame_type, $offset_delta, $locals) = @_;

  MarpaX::Java::ClassFile::Struct::AppendFrame->new(
                                                    frame_type   => $_[1],
                                                    offset_delta => $_[2],
                                                    locals       => $_[3]
                                                   )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'offset_delta$' = completed offset_delta
append_frame ::= frame_type offset_delta locals action => _append_frame
frame_type          ::= U1                      action => u1
offset_delta        ::= U2                      action => u2
locals              ::= MANAGED                 action => ::first
