use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantValueAttribute;
use Moo;

# ABSTRACT: Parsing of a Signature_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantValueAttribute;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"        => sub { $_[0]->exhausted },
                        'attribute_length$' => sub {
                          my $attribute_length = $_[0]->literalU4('attribute_length');
                          $_[0]->fatalf('attribute_length is %d instead of 2', $attribute_length) unless ($attribute_length == 2)
                        },
                        'constantvalue_index$' => sub {
                          my $constantvalue_index = $_[0]->literalU2('constantvalue_index');
                          #
                          # The value of the constantvalue_index item must be a valid index into the constant_pool table.
                          # The constant_pool entry at that index gives the constant value represented by this attribute.
                          # The constant_pool entry must be of a type appropriate to the field,
                          #
                          my $constantvalue = $_[0]->getAndCheckCpInfo($constantvalue_index)
                        }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _ConstantValue_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $constantvalue_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantValueAttribute->new(
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
event 'attribute_length$' = completed attribute_length
event 'constantvalue_index$' = completed constantvalue_index
ConstantValue_attribute ::=
    attribute_name_index
    attribute_length
    constantvalue_index
  action => _ConstantValue_attribute

attribute_name_index ::= U2 action => u2
attribute_length     ::= U4 action => u4
constantvalue_index  ::= U2 action => u2
