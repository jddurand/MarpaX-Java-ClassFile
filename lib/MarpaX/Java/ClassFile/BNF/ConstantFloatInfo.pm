use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantFloatInfo;
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
require MarpaX::Java::ClassFile::Struct::ConstantFloatInfo;

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
sub _ConstantFloatInfo {
  # my ($self, $tag, $bytes) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantFloatInfo->new(
                                                          tag        => $_[1],
                                                          bytes      => $_[2],
                                                          _perlvalue => $_[0]->float($_[2])
                                                         )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
ConstantFloatInfo ::= tag U4   action => _ConstantFloatInfo
tag               ::= [\x{04}] action => u1
