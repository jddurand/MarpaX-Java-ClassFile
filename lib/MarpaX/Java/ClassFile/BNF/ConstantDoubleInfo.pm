use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantDoubleInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_Double_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantDoubleInfo;
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
sub _ConstantDoubleInfo {
  # my ($self, $tag, $high_bytes, $low_bytes) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantDoubleInfo->new(
                                                           tag        => $_[0]->u1($_[1]),
                                                           high_bytes => $_[2],
                                                           low_bytes  => $_[3],
                                                           _value     => $_[0]->long($_[2], $_[3])
                                                          )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantDoubleInfo ::=
             [\x{06}] # tag
             U4       # high_bytes
             U4       # low_bytes
  action => _ConstantDoubleInfo
