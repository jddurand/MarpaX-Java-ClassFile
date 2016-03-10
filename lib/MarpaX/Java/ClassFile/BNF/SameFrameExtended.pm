use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SameFrameExtended;
use Moo;

# ABSTRACT: Parsing of a same_frame_extended

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::SameFrameExtended;
use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

has preloaded_frame_type => (is => 'ro', required => 1, isa => U1);

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"    => sub { $_[0]->exhausted },
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _same_frame_extended {
  # my ($self, $frame_type, $offset_delta) = @_;

  MarpaX::Java::ClassFile::Struct::SameFrameExtended->new(
                                                          frame_type   => $_[1],
                                                          offset_delta => $_[2]
                                                         )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
same_frame_extended ::= frame_type offset_delta action => _same_frame_extended
frame_type          ::= U1                      action => u1
offset_delta        ::= U2                      action => u2
