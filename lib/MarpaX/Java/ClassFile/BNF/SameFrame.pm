use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SameFrame;
use Moo;

# ABSTRACT: Parsing of a same_frame

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::SameFrame;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

has preloaded_frame_type => (is => 'ro', required => 1, isa => U1);

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"        => sub { $_[0]->exhausted },
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _same_frame {
  # my ($self, $frame_type) = @_;

  MarpaX::Java::ClassFile::Struct::SameFrame->new(
                                                  frame_type => $_[1]
                                                 )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
same_frame ::= frame_type action => _same_frame
frame_type ::= U1         action => u1
