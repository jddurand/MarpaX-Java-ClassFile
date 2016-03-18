use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantMethodHandleInfo;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_MethodHandle_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 ConstantPoolArray/;
use Types::Standard qw/ArrayRef/;

has _constant_pool  => ( is => 'rw', required => 1, isa => ConstantPoolArray);
has tag             => ( is => 'ro', required => 1, isa => U1 );
has reference_kind  => ( is => 'ro', required => 1, isa => U1 );
has reference_index => ( is => 'ro', required => 1, isa => U2 );

sub _stringify {
  # my ($self) = @_;

  my $reference_index         = $_[0]->reference_index;
  my $constant_reference      = $_[0]->_constant_pool->get($_[0]->reference_index);

  "MethodHandleInfo{#$reference_index => $constant_reference}"
}

1;
