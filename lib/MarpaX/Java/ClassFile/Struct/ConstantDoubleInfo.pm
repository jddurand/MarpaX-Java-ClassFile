use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantDoubleInfo;
use Moo;

# ABSTRACT: CONSTANT_Double_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Encodings qw/Bytes/;
use Types::Standard -all;

has tag          => ( is => 'ro', isa => U1 );
has high_bytes   => ( is => 'ro', isa => Bytes );
has low_bytes    => ( is => 'ro', isa => Bytes );
has _value       => ( is => 'ro', isa => InstanceOf['Math::BigFloat'] );

1;
