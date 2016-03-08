use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantLongInfo;
use Moo;

# ABSTRACT: CONSTANT_Long_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag          => ( is => 'ro', isa => U1 );
has high_bytes   => ( is => 'ro', isa => U4 );
has low_bytes    => ( is => 'ro', isa => U4 );

1;
