use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::FormalParameterTarget;
use Moo;

# ABSTRACT: formal_parameter_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has formal_parameter_index  => ( is => 'ro', isa => U1 );

1;
