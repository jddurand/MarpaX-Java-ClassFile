use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ChopFrame;
use Moo;

# ABSTRACT: Parsing of a chop_frame

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/bnf/;
use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;
use MarpaX::Java::ClassFile::Util::ProductionMode qw/prod_isa/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ChopFrame;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

has preloaded_frame_type => (is => 'ro', required => 1, prod_isa(U1));

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
sub _chop_frame {
  # my ($self, $frame_type, $offset_delta) = @_;

  MarpaX::Java::ClassFile::Struct::ChopFrame->new(
                                                  frame_type   => $_[1],
                                                  offset_delta => $_[2]
                                                 )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
chop_frame   ::= frame_type offset_delta action => _chop_frame
frame_type   ::= U1                      action => u1
offset_delta ::= U2                      action => u2
