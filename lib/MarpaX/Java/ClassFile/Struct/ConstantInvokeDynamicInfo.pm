use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantInvokeDynamicInfo;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_InvokeDynamic_info entry

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 ConstantPoolArray/;
use Types::Standard qw/ArrayRef/;

has _constant_pool              => ( is => 'rw', required => 1, isa => ConstantPoolArray);
has tag                         => ( is => 'ro', required => 1, isa => U1 );
has bootstrap_method_attr_index => ( is => 'ro', required => 1, isa => U2 );
has name_and_type_index         => ( is => 'ro', required => 1, isa => U2 );

sub _stringify {
  # my ($self) = @_;

  my $bootstrap_method_attr_index = $_[0]->bootstrap_method_attr_index;
  my $name_and_type_index         = $_[0]->name_and_type_index;

  my $constant_bootstrap_method_attr = $_[0]->_constant_pool->get($_[0]->class_index);
  my $constant_name_and_type         = $_[0]->_constant_pool->get($_[0]->name_and_type_index);

  "InvokeDynamicInfo{#$bootstrap_method_attr_index => $constant_bootstrap_method_attr, #$name_and_type_index => $constant_name_and_type}"
}

1;
