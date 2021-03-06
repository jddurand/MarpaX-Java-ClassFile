use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SameFrameExtended;
use Moo;

# ABSTRACT: Parsing of a same_frame_extended

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;
use MarpaX::Java::ClassFile::Util::ProductionMode qw/prod_isa/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::SameFrameExtended;

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
sub _same_frame_extended {
  # my ($self, $frame_type, $offset_delta) = @_;

  MarpaX::Java::ClassFile::Struct::SameFrameExtended->new(
                                                          frame_type   => $_[1],
                                                          offset_delta => $_[2]
                                                         )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
same_frame_extended ::= frame_type offset_delta action => _same_frame_extended
frame_type          ::= U1                      action => u1
offset_delta        ::= U2                      action => u2
