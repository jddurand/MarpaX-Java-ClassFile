use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::EnclosingMethodAttribute;
use Moo;

# ABSTRACT: Parsing of a Signature_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::EnclosingMethodAttribute;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted" => sub { $_[0]->exhausted }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _EnclosingMethod_attribute {
  # my ($self, $attribute_name_index, $class_index, $method_index) = @_;

  MarpaX::Java::ClassFile::Struct::EnclosingMethodAttribute->new(
                                                                 _constant_pool       => $_[0]->constant_pool,
                                                                 attribute_name_index => $_[1],
                                                                 attribute_length     => $_[2],
                                                                 class_index          => $_[3],
                                                                 method_index         => $_[4]
                                                              )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
EnclosingMethod_attribute ::= attribute_name_index attribute_length class_index method_index action => _EnclosingMethod_attribute
attribute_name_index      ::= U2                                                        action => u2
attribute_length          ::= U4                                                        action => u4
class_index               ::= U2                                                        action => u2
method_index              ::= U2                                                        action => u2
