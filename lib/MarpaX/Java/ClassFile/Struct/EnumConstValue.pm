use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::EnumConstValue;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { '#' . $_[0]->type_name_index }  => sub { $_[0]->_constant_pool->[$_[0]->type_name_index] } ],
           [ sub { '#' . $_[0]->const_name_index } => sub { $_[0]->_constant_pool->[$_[0]->const_name_index] } ]
          ];

# ABSTRACT: enum constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool   => ( is => 'rw', required => 1, isa => ArrayRef);
has type_name_index  => ( is => 'ro', required => 1, isa => U2 );
has const_name_index => ( is => 'ro', required => 1, isa => U2 );

1;
