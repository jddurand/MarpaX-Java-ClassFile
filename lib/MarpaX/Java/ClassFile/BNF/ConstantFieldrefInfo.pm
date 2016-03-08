use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantFieldrefInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_Fieldref_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantFieldrefInfo;
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
sub _ConstantFieldrefInfo {
  my ($self, $class_index, $name_and_type_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantFieldrefInfo->new(
                                                              tag                 => 9,
                                                              class_index         => $class_index,
                                                              name_and_type_index => $name_and_type_index
                                                             )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantFieldrefInfo ::=
             u2      # class_index
             u2      # name_and_type_index
  action => _ConstantFieldrefInfo
