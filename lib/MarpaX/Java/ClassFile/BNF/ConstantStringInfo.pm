use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantStringInfo;
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
require MarpaX::Java::ClassFile::Struct::ConstantStringInfo;

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
sub _ConstantStringInfo {
  # my ($self, $tag, $string_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantStringInfo->new(
                                                           tag          => $_[1],
                                                           string_index => $_[2]
                                                          )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
ConstantStringInfo ::= [\x{08}] string_index action => _ConstantStringInfo
string_index       ::= U2               action => u2
