use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ElementValuePair;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Element name#' . $_[0]->element_name_index } => sub { $_[0]->_constant_pool->[$_[0]->element_name_index] } ],
           [ sub { 'Value'                                     } => sub { $_[0]->value } ]
          ];

# ABSTRACT: element value pair

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 ElementValue/;
use Types::Standard qw/ArrayRef/;

has _constant_pool     => ( is => 'rw', required => 1, isa => ArrayRef);
has element_name_index => ( is => 'ro', required => 1, isa => U2 );
has value              => ( is => 'ro', required => 1, isa => ElementValue );

1;
