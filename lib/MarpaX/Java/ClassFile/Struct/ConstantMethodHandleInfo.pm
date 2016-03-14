use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantMethodHandleInfo;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: CONSTANT_MethodHandle_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;

has tag             => ( is => 'ro', required => 1, isa => U1 );
has reference_kind  => ( is => 'ro', required => 1, isa => U1 );
has reference_index => ( is => 'ro', required => 1, isa => U2 );

1;
