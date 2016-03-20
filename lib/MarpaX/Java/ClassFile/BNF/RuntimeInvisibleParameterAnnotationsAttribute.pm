use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::RuntimeInvisibleParameterAnnotationsAttribute;
use Moo;

# ABSTRACT: Parsing of a RuntimeInvisibleParameterAnnotations_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::RuntimeInvisibleParameterAnnotationsAttribute;
require MarpaX::Java::ClassFile::BNF::ParameterAnnotationArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"      => sub { $_[0]->exhausted },
                        'num_parameters$' => sub { $_[0]->inner('ParameterAnnotationArray', size => $_[0]->literalU1('num_parameters')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _RuntimeInvisibleParameterAnnotations_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $num_parameters, $parameter_annotations) = @_;

  MarpaX::Java::ClassFile::Struct::RuntimeInvisibleParameterAnnotationsAttribute->new(
                                                                                      attribute_name_index  => $_[1],
                                                                                      attribute_length      => $_[2],
                                                                                      num_parameters        => $_[3],
                                                                                      parameter_annotations => $_[4]
                                                                                     )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'num_parameters$' = completed num_parameters

RuntimeInvisibleParameterAnnotations_attribute ::= attribute_name_index attribute_length num_parameters parameter_annotations action => _RuntimeInvisibleParameterAnnotations_attribute
attribute_name_index   ::= U2                                                                                               action => u2
attribute_length       ::= U4                                                                                               action => u4
num_parameters         ::= U1                                                                                               action => u1
parameter_annotations  ::= MANAGED                                                                                          action => ::first
