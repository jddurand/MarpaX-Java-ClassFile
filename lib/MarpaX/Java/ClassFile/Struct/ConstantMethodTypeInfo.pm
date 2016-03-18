use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantMethodTypeInfo;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_MethodType_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 ConstantPoolArray/;
use Types::Standard qw/ArrayRef/;

has _constant_pool   => ( is => 'rw', required => 1, isa => ConstantPoolArray);
has tag              => ( is => 'ro', required => 1, isa => U1 );
has descriptor_index => ( is => 'ro', required => 1, isa => U2 );

sub _stringify {
  # my ($self) = @_;

  my $descriptor_index    = $_[0]->descriptor_index;
  my $constant_descriptor = $_[0]->_constant_pool->get($_[0]->descriptor_index);

  "MethodTypeInfo{#$descriptor_index => $constant_descriptor}"
}

1;
