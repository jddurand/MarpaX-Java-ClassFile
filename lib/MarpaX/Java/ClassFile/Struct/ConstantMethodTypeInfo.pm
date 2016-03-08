use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantMethodTypeInfo;
use Moo;

# ABSTRACT: CONSTANT_MethodType_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag              => ( is => 'ro', isa => U1 );
has descriptor_index => ( is => 'ro', isa => U2 );

1;
