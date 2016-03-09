use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantIntegerInfo;
use Moo;

# ABSTRACT: CONSTANT_Integer_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;
use Types::Encodings qw/Bytes/;

has tag          => ( is => 'ro', isa => U1 );
has bytes        => ( is => 'ro', isa => Bytes );
has _value       => ( is => 'ro', isa => Int );

1;
