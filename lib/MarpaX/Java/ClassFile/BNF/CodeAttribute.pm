use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::CodeAttribute;
use Moo;

# ABSTRACT: Parsing of a Code_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::CodeAttribute;
use MarpaX::Java::ClassFile::BNF::AttributesArray;
use MarpaX::Java::ClassFile::BNF::ExceptionTableArray;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"              => sub { $_[0]->exhausted },
                        'code_length$'            => sub { $_[0]->lexeme_read_managed($_[0]->literalU4) },
                        'exception_table_length$' => sub { $_[0]->inner('ExceptionTableArray', size => $_[0]->literalU2('exception_table_length')) },
                        'attributes_count$'       => sub { $_[0]->inner('AttributesArray', size => $_[0]->literalU2('attributes_count')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _Code_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $max_stack, $max_locals, $code_length, $code, $exception_table_length, $exception_table, $attributes_count, $attributes) = @_;

  MarpaX::Java::ClassFile::Struct::CodeAttribute->new(
                                                      attribute_name_index => $_[1],
                                                      attribute_length     => $_[2],
                                                      constantvalue_index  => $_[3]
                                                     )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'code_length$'            = completed code_length
event 'exception_table_length$' = completed exception_table_length
event 'attributes_count$'       = completed attributes_count
Code_attribute ::=
    attribute_name_index
    attribute_length
    max_stack
    max_locals
    code_length
    code
    exception_table_length
    exception_table
    attributes_count
    attributes
  action => _Code_attribute

attribute_name_index   ::= U2      action => u2
attribute_length       ::= U4      action => u4
max_stack              ::= U2      action => u2
max_locals             ::= U2      action => u2
code_length            ::= U4      action => u4
code                   ::= MANAGED action => ::first
exception_table_length ::= U2      action => u2
exception_table        ::= MANAGED action => ::first
attributes_count       ::= U2      action => u2
attributes             ::= MANAGED action => ::first
