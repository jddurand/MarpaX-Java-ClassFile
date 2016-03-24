use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstValueIndex;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool const_value_index/],
  '""' => [
           [ sub { 'Constant value#' . $_[0]->const_value_index } => sub { $_[0]->_constant_pool->[$_[0]->const_value_index] } ]
          ];

# ABSTRACT: constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

use Types::Standard qw/ArrayRef/;

has _constant_pool    => ( is => 'rw', required => 1, isa => ArrayRef);
has const_value_index => ( is => 'ro', required => 1, isa => U2 );

1;
