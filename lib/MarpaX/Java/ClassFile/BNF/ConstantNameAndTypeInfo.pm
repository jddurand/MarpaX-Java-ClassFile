use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantNameAndTypeInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_NameAndType_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ConstantNameAndTypeInfo;

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
sub _ConstantNameAndTypeInfo {
  # my ($self, $tag, $name_index, $descriptor_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantNameAndTypeInfo->new(
                                                                tag              => $_[1],
                                                                name_index       => $_[2],
                                                                descriptor_index => $_[3]
                                                               )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
ConstantNameAndTypeInfo ::= tag name_index descriptor_index action => _ConstantNameAndTypeInfo
tag                     ::= [\x{0c}]                        action => u1
name_index              ::= U2                              action => u2
descriptor_index        ::= U2                              action => u2
