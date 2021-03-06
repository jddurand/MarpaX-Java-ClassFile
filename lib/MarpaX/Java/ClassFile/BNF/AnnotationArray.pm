use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::AnnotationArray;
use Moo;

# ABSTRACT: Parsing an array of annotation

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/bnf/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::BNF::Annotation;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"      => sub { $_[0]->exhausted },
          '^annotationArray' => sub {
            foreach (1..$_[0]->size) {
              $_[0]->inner_silent('Annotation');
              $_[0]->inc_nbDone
            }
          }
         }
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event '^annotationArray' = predicted annotationArray

annotationArray ::= MANAGED*
