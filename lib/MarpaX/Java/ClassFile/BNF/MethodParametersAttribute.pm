use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::MethodParametersAttribute;
use Moo;

# ABSTRACT: Parsing of a MethodParameters_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::MethodParametersAttribute;
require MarpaX::Java::ClassFile::BNF::ParameterArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          "'exhausted"             => sub { $_[0]->exhausted },
          'parameters_count$' => sub { $_[0]->inner('ParameterArray', size => $_[0]->literalU1('parameters_count')) }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _MethodParametersAttribute {
  # my ($self, $attribute_name_index, $attribute_length, $parameters_count, $parameters) = @_;

  MarpaX::Java::ClassFile::Struct::AnnotationDefaultAttribute->new(
                                                                   attribute_name_index  => $_[1],
                                                                   attribute_length      => $_[2],
                                                                   parameters_count      => $_[3],
                                                                   parameters            => $_[4]
                                                                  )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
MethodParametersAttribute  ::= attribute_name_index attribute_length parameters_count parameters action => _MethodParametersAttribute
attribute_name_index       ::= U2                                                                action => u2
attribute_length           ::= U4                                                                action => u4
parameters_count           ::= U1                                                                action => u1
parameters                 ::= MANAGED                                                           action => ::first
