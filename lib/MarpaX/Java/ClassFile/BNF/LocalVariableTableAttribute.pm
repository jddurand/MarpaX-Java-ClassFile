use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::LocalVariableTableAttribute;
use Moo;

# ABSTRACT: Parsing of a LocalVariableTable_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::LocalVariableTableAttribute;
use MarpaX::Java::ClassFile::BNF::LocalVariableArray;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"                   => sub { $_[0]->exhausted },
                        'local_variable_table_length$' => sub { $_[0]->inner('LocalVariableArray', size => $_[0]->literalU2('local_variable_table_length')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _LocalVariableTable_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $local_variable_table_length, $local_variable_table) = @_;

  MarpaX::Java::ClassFile::Struct::LocalVariableTableAttribute->new(
                                                                    attribute_name_index        => $_[1],
                                                                    attribute_length            => $_[2],
                                                                    local_variable_table_length => $_[3],
                                                                    local_variable_table        => $_[4]
                                                                   )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'local_variable_table_length$' = completed local_variable_table_length

LocalVariableTable_attribute ::= attribute_name_index attribute_length local_variable_table_length local_variable_table action => _LocalVariableTable_attribute
attribute_name_index         ::= U2                                                                                     action => u2
attribute_length             ::= U4                                                                                     action => u4
local_variable_table_length  ::= U2                                                                                     action => u2
local_variable_table         ::= MANAGED                                                                                action => ::first
