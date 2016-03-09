use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantClassInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_Class_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantClassInfo;
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
sub _ConstantClassInfo {
  # my ($self, $tag, $name_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantClassInfo->new(
                                                          tag        => $_[0]->u1($_[1]),
                                                          name_index => $_[0]->u2($_[2]),
                                                          )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantClassInfo ::=
             [\x{07}] # tag
             U2       # name_index
  action => _ConstantClassInfo
