use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantLongInfo;
use Moo;

# ABSTRACT: CONSTANT_Long_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;
use Types::Encodings qw/Bytes/;

has tag          => ( is => 'ro', required => 1, isa => U1 );
has high_bytes   => ( is => 'ro', required => 1, isa => Bytes );
has low_bytes    => ( is => 'ro', required => 1, isa => Bytes );
has _value       => ( is => 'ro', required => 1, isa => Int );

1;
