use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantUnmanagedInfo;
use Moo;

# ABSTRACT: unmanaged constant pool entry

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag  => ( is => 'ro', isa => U1 );
has info => ( is => 'ro', isa => ArrayRef[U1] );

1;
