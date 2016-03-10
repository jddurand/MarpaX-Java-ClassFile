use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::EnumConstValue;
use Moo;

# ABSTRACT: Parsing of a enum_const_value

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::EnumConstValue;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"  => sub { $_[0]->exhausted },
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _EnumConstValue {
  # my ($self, $type_name_index, $const_name_index) = @_;

  MarpaX::Java::ClassFile::Struct::EnumConstValue->new(
                                                       type_name_index  => $_[1],
                                                       const_name_index => $_[2],
                                                      )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
EnumConstValue   ::= type_name_index const_name_index action => _EnumConstValue
type_name_index  ::= U2                               action => u2
const_name_index ::= U2                               action => u2
