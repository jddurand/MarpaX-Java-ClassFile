use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantNameAndTypeInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_NameAndType_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantNameAndTypeInfo;
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
sub _ConstantNameAndTypeInfo {
  my ($self, $name_index, $descriptor_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantNameAndTypeInfo->new(
                                                          tag              => 12,
                                                          name_index       => $name_index,
                                                          descriptor_index => $descriptor_index
                                                          )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantNameAndTypeInfo ::=
             u2      # name_index
             u2      # descriptor_index
  action => _ConstantNameAndTypeInfo
