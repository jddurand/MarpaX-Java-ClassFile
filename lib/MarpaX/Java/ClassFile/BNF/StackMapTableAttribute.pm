use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::StackMapTableAttribute;
use Moo;

# ABSTRACT: Parsing of a StackMapTable_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::StackMapTableAttribute;
require MarpaX::Java::ClassFile::BNF::StackMapFrameArray;

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

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'number_of_entries$' = completed number_of_entries
StackMapTable_attribute ::= attribute_name_index attribute_length number_of_entries entries action => _StackMapTable_attribute
attribute_name_index    ::= U2                                                              action => u2
attribute_length        ::= U4                                                              action => u4
number_of_entries       ::= U2                                                              action => u2
entries                 ::= MANAGED                                                         action => ::first
