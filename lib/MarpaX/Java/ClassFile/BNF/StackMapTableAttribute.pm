use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::StackMapTableAttribute;
use Moo;

# ABSTRACT: Parsing of a StackMapTable_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::StackMapTableAttribute;
use MarpaX::Java::ClassFile::BNF::StackMapFrameArray;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"         => sub { $_[0]->exhausted },
                        'number_of_entries$' => sub { $_[0]->inner('StackMapFrameArray', size => $_[0]->literalU2('number_of_entries')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _StackMapTable_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $number_of_entries, $entries) = @_;

  MarpaX::Java::ClassFile::Struct::StackMapTableAttribute->new(
                                                               attribute_name_index => $_[1],
                                                               attribute_length     => $_[2],
                                                               number_of_entries    => $_[3],
                                                               entries              => $_[4]
                                                              )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'number_of_entries$' = completed number_of_entries
StackMapTable_attribute ::= attribute_name_index attribute_length number_of_entries entries action => _StackMapTable_attribute
attribute_name_index    ::= U2                                                              action => u2
attribute_length        ::= U4                                                              action => u4
number_of_entries       ::= U2                                                              action => u2
entries                 ::= MANAGED                                                         action => ::first
