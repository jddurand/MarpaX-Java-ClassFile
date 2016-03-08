use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantMethodHandleInfo;
use Moo;

# ABSTRACT: CONSTANT_MethodHandle_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag             => ( is => 'ro', isa => U1 );
has reference_kind  => ( is => 'ro', isa => U1 );
has reference_index => ( is => 'ro', isa => U2 );

1;
