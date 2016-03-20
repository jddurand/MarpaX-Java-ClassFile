use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::TypeParameterTarget;
use Moo;

# ABSTRACT: Parsing of a type_parameter_target

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::TypeParameterTarget;

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
sub _TypeParameterTarget {
  # my ($self, $type_parameter_index) = @_;

  MarpaX::Java::ClassFile::Struct::TypeParameterTarget->new(
                                                            type_parameter_index => $_[1]
                                                           )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
typeParameterTarget  ::= type_parameter_index action => _TypeParameterTarget
type_parameter_index ::= U1                   action => u1
