use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantMethodTypeInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_MethodType_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantMethodTypeInfo;
use Types::Standard -all;

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
                                                              tag                 => $_[0]->u1($_[1]),
                                                              descriptor_index    => $_[0]->u2($_[2])
                                                             )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantMethodTypeInfo ::=
             [\x{0a}] # tag
             U2       # descriptor_index
  action => _ConstantMethodTypeInfo
