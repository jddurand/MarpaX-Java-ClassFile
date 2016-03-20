use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SupertypeTarget;
use Moo;

# ABSTRACT: Parsing of a supertype_target

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::SupertypeTarget;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return { "'exhausted" => sub { $_[0]->exhausted } } }

# ---------------
# Grammar actions
# ---------------
sub _SupertypeTarget {
  # my ($self, $supertype_index) = @_;

  MarpaX::Java::ClassFile::Struct::SupertypeTarget->new(
                                                        supertype_index => $_[1]
                                                       )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
supertypeTarget ::= supertype_index action => _SupertypeTarget
supertype_index ::= U2              action => u2
