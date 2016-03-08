use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantUtf8Info;
use Moo;

# ABSTRACT: CONSTANT_Utf8_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag          => ( is => 'ro', required => 1, isa => U1 );
has length       => ( is => 'ro', required => 1, isa => U2 );
has bytes        => ( is => 'ro', required => 1, isa => ArrayRef[U1] );
has _value       => ( is => 'ro', required => 1, isa => Str|Undef );

1;
