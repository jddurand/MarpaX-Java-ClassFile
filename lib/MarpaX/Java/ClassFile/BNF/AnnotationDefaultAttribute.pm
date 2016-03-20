use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::AnnotationDefaultAttribute;
use Moo;

# ABSTRACT: Parsing of an AnnotationDefault_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::AnnotationDefaultAttribute;
require MarpaX::Java::ClassFile::BNF::ElementValue;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          "'exhausted"        => sub { $_[0]->exhausted },
          'attribute_length$' => sub { $_[0]->inner('ElementValue') }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _AnnotationDefaultAttribute {
  # my ($self, $attribute_name_index, $attribute_length, $default_value) = @_;

  MarpaX::Java::ClassFile::Struct::AnnotationDefaultAttribute->new(
                                                                   attribute_name_index => $_[1],
                                                                   attribute_length     => $_[2],
                                                                   default_value        => $_[3]
                                                                  )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
AnnotationDefaultAttribute ::= attribute_name_index attribute_length default_value action => _AnnotationDefaultAttribute
attribute_name_index       ::= U2                                                  action => u2
attribute_length           ::= U4                                                  action => u4
default_value              ::= MANAGED                                             action => ::first
