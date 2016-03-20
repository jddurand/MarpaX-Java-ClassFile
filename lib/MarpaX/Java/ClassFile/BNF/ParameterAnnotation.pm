use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ParameterAnnotation;
use Moo;

# ABSTRACT: Parsing of a parameter_annotation

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/bnf/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ParameterAnnotation;
require MarpaX::Java::ClassFile::BNF::AnnotationArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"      => sub { $_[0]->exhausted },
          'num_annotations$' => sub { $_[0]->inner('AnnotationArray', size => $_[0]->literalU2('num_annotations')) }
         }
}

sub _parameterAnnotation {
  # my ($self, $num_annotations, $annotations) = @_;

  MarpaX::Java::ClassFile::Struct::ParameterAnnotation->new(
                                                            num_annotations => $_[1],
                                                            annotations     => $_[2]
                                                  )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'num_annotations$' = completed num_annotations

parameterAnnotation ::= num_annotations annotations action => _parameterAnnotation
num_annotations     ::= U2           action => u2
annotations         ::= MANAGED      action => ::first
