use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantInvokeDynamicInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_InvokeDynamic_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ConstantInvokeDynamicInfo;

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
sub _ConstantInvokeDynamicInfo {
  # my ($self, $tag, $class_index, $name_and_type_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantInvokeDynamicInfo->new(
                                                              tag                         => $_[1],
                                                              bootstrap_method_attr_index => $_[2],
                                                              name_and_type_index         => $_[3]
                                                             )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
ConstantInvokeDynamicInfo   ::= tag bootstrap_method_attr_index name_and_type_index action => _ConstantInvokeDynamicInfo
tag                         ::= [\x{12}]                                            action => u1
bootstrap_method_attr_index ::= U2                                                  action => u2
name_and_type_index         ::= U2                                                  action => u2
