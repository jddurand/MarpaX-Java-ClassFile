use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantClassInfo;
use Moo;

# ABSTRACT: CONSTANT_Class_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag        => ( is => 'ro', isa => U1 );
has name_index => ( is => 'ro', isa => U2 );

1;
