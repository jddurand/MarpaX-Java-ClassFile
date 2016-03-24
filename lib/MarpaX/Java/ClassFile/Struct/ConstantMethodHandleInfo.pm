use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantMethodHandleInfo;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool tag reference_kind reference_index/],
  '""' => [
           [ sub { 'Reference kind' }                      => sub { $_[0]->reference_kind } ],
           [ sub { 'Reference#' . $_[0]->reference_index } => sub { $_[0]->_constant_pool->[$_[0]->reference_index] } ]
         ];

# ABSTRACT: CONSTANT_MethodHandle_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool  => ( is => 'rw', required => 1, isa => ArrayRef);
has tag             => ( is => 'ro', required => 1, isa => U1 );
has reference_kind  => ( is => 'ro', required => 1, isa => U1 );
has reference_index => ( is => 'ro', required => 1, isa => U2 );

1;
