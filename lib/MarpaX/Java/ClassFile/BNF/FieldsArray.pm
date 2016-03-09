use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::FieldsArray;
use Moo;

# ABSTRACT: Parsing an array of field

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::FieldInfo;
use MarpaX::Java::ClassFile::BNF::AttributesArray;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted" => sub { $_[0]->exhausted },
          'field_info$' => sub { $_[0]->inc_nbDone },
          'attributes_count$' => sub { $_[0]->inner('AttributesArray', size => $_[0]->literalU2('attributes_count')) }
         }
}

sub _field_info {
  my ($self, $access_flags, $name_index, $descriptor_index, $attributes_count, $attributes) = @_;

  MarpaX::Java::ClassFile::Struct::FieldInfo->new(
                                                  access_flags     => $access_flags,
                                                  name_index       => $name_index,
                                                  descriptor_index => $descriptor_index,
                                                  attributes_count => $attributes_count,
                                                  attributes       => $attributes
                                                 )
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'attributes_count$' = completed attributes_count
event 'field_info$' = completed field_info

fieldsArray ::= field_info*

field_info ::=
  access_flags
  name_index
  descriptor_index
  attributes_count
  attributes
  action => _field_info

access_flags     ::= U2           action => u2
name_index       ::= U2           action => u2
descriptor_index ::= U2           action => u2
attributes_count ::= U2           action => u2
attributes       ::= MANAGED      action => ::first
