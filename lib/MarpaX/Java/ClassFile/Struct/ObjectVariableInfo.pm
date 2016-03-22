use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ObjectVariableInfo;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'ITEM_Object' } ],
           [ sub { 'Index#' . $_[0]->cpool_index } => sub { $_[0]->_constant_pool->[$_[0]->cpool_index] } ]
          ];

# ABSTRACT: Object_variable_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool => ( is => 'rw', required => 1, isa => ArrayRef);
has tag            => ( is => 'ro', required => 1, isa => U1 );
has cpool_index    => ( is => 'ro', required => 1, isa => U2 );

1;
