use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantInterfaceMethodrefInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_InterfaceMethodref_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantInterfaceMethodrefInfo;
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
sub _ConstantInterfaceMethodrefInfo {
  my ($self, $class_index, $name_and_type_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantInterfaceMethodrefInfo->new(
                                                              tag                 => 11,
                                                              class_index         => $class_index,
                                                              name_and_type_index => $name_and_type_index
                                                             )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantInterfaceMethodrefInfo ::=
             u2      # class_index
             u2      # name_and_type_index
  action => _ConstantInterfaceMethodrefInfo
