use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantValueAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: ConstantValue_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 ConstantPoolArray/;
use Types::Standard qw/ArrayRef/;

has _constant_pool        => ( is => 'rw', required => 1, isa => ConstantPoolArray);
has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has constantvalue_index   => ( is => 'ro', required => 1, isa => U2 );

sub _stringify {
  # my ($self) = @_;

  my $attribute_name_index = $_[0]->attribute_name_index;
  my $attribute_length     = $_[0]->attribute_length;
  my $constantvalue_index  = $_[0]->constantvalue_index;

  my $constant_attribute_name = $_[0]->_constant_pool->get($_[0]->attribute_name_index);
  my $constant_constantvalue  = $_[0]->_constant_pool->get($_[0]->constantvalue_index);

  "ValueAttribute{#$attribute_name_index => $constant_attribute_name, attribute_length=$attribute_length, #$constantvalue_index => $constant_constantvalue}"
}

1;
