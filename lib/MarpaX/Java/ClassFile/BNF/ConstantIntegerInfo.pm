use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantIntegerInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_NameAndType_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantIntegerInfo;
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
sub _ConstantIntegerInfo {
  my ($self, $U4) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantIntegerInfo->new(
                                                            tag     => 3,
                                                            bytes   => $self->toU1ArrayRef($U4),
                                                            _value  => $self->integer($U4)
                                                          )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantIntegerInfo ::=
             U4      # bytes
  action => _ConstantIntegerInfo
