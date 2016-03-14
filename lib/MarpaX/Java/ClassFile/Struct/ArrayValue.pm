use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ArrayValue;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 ElementValue/;
use Types::Standard qw/ArrayRef/;

has num_values => ( is => 'ro', required => 1, isa => U2 );
has values     => ( is => 'ro', required => 1, isa => ArrayRef[ElementValue] );

1;
