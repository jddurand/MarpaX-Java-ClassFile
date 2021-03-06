use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstValueIndex;
use Moo;

# ABSTRACT: Parsing of a const_value_index

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ConstValueIndex;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"  => sub { $_[0]->exhausted },
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _ConstValueIndex {
  # my ($self, $const_value_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstValueIndex->new(
                                                        _constant_pool    => $_[0]->constant_pool,
                                                        const_value_index => $_[1]
                                                       )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
ConstValueIndex   ::= const_value_index action => _ConstValueIndex
const_value_index ::= U2                action => u2
