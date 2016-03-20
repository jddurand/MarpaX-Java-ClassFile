use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::FormalParameterTarget;
use Moo;

# ABSTRACT: Parsing of a formal_parameter_target

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::FormalParameterTarget;

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
sub _FormalParameterTarget {
  # my ($self, $formal_parameter_index) = @_;

  MarpaX::Java::ClassFile::Struct::FormalParameterTarget->new(
                                                              formal_parameter_index => $_[1]
                                                             )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
formalParameterTarget  ::= formal_parameter_index action => _FormalParameterTarget
formal_parameter_index ::= U1                   action => u1
