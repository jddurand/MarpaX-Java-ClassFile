use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstValueIndex;
use Moo;

# ABSTRACT: constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has const_value_index => ( is => 'ro', required => 1, isa => U2 );

1;
