use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantValueAttribute;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool attribute_name_index attribute_length constantvalue_index/],
  '""' => [
           [ sub { 'Constant value#' . $_[0]->constantvalue_index  } => sub { $_[0]->_constant_pool->[$_[0]->constantvalue_index] } ]
          ];

# ABSTRACT: ConstantValue_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;
use Types::Standard qw/ArrayRef/;

has _constant_pool        => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has constantvalue_index   => ( is => 'ro', required => 1, isa => U2 );

1;
