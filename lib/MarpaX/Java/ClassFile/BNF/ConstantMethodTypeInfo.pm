use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantMethodTypeInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_MethodType_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ConstantMethodTypeInfo;

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
sub _ConstantMethodTypeInfo {
  # my ($self, $tag, $descriptor_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantMethodTypeInfo->new(
                                                              tag              => $_[1],
                                                              descriptor_index => $_[2]
                                                             )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
ConstantMethodTypeInfo ::= tag descriptor_index action => _ConstantMethodTypeInfo
tag                    ::= [\x{0a}]             action => u1
descriptor_index       ::= U2                   action => u2
