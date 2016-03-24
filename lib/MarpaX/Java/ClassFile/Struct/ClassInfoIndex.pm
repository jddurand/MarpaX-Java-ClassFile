use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ClassInfoIndex;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool class_info_index/],
  '""' => [
           [ sub { 'Class info#' . $_[0]->class_info_index } => sub { $_[0]->_constant_pool->[$_[0]->class_info_index] } ]
          ]
  ;

# ABSTRACT: Element's value class_info_index

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool   => ( is => 'rw', required => 1, isa => ArrayRef);
has class_info_index => ( is => 'ro', required => 1, isa => U2 );

1;
