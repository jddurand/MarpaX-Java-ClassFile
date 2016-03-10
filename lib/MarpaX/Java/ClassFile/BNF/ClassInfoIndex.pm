use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ClassInfoIndex;
use Moo;

# ABSTRACT: Parsing of a class_info_index

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ClassInfoIndex;
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
sub _ClassInfoIndex {
  # my ($self, $const_value_index) = @_;

  MarpaX::Java::ClassFile::Struct::ClassInfoIndex->new(
                                                       class_info_index => $_[1]
                                                      )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ClassInfoIndex   ::= class_info_index action => _ClassInfoIndex
class_info_index ::= U2               action => u2
