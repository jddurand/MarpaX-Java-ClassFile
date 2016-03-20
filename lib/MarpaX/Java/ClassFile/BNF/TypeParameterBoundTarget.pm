use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::TypeParameterBoundTarget;
use Moo;

# ABSTRACT: Parsing of a type_parameter_bound_target

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::TypeParameterBoundTarget;

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
sub _TypeParameterBoundTarget {
  # my ($self, $type_parameter_index) = @_;

  MarpaX::Java::ClassFile::Struct::TypeParameterBoundTarget->new(
                                                                 type_parameter_index => $_[1],
                                                                 bound_index          => $_[2]
                                                                )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
typeParameterBoundTarget ::= type_parameter_index bound_index action => _TypeParameterBoundTarget
type_parameter_index     ::= U1                               action => u1
bound_index              ::= U1                               action => u1
