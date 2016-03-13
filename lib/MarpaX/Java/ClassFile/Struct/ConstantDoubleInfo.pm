use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantDoubleInfo;
use Moo;

# ABSTRACT: CONSTANT_Double_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;
use Types::Encodings qw/Bytes/;
use Types::Standard qw/InstanceOf/;

has tag          => ( is => 'ro', required => 1, isa => U1 );
has high_bytes   => ( is => 'ro', required => 1, isa => Bytes );
has low_bytes    => ( is => 'ro', required => 1, isa => Bytes );
has _value       => ( is => 'ro', required => 1, isa => InstanceOf['Math::BigFloat'] );

1;
