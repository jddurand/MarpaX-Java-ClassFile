use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ArrayValue;
use Moo;

# ABSTRACT: constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has num_values => ( is => 'ro', required => 1, isa => U2 );
has values     => ( is => 'ro', required => 1, isa => ArrayRef[ElementValue] );

1;
