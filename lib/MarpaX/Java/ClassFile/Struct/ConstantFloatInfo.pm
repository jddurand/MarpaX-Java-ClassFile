use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantFloatInfo;
use Moo;

# ABSTRACT: CONSTANT_Float_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag          => ( is => 'ro', isa => U1 );
has bytes        => ( is => 'ro', isa => U4 );

1;
