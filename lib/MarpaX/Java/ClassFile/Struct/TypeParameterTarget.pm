use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypeParameterTarget;
use Moo;

# ABSTRACT: type_parameter_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has type_parameter_index  => ( is => 'ro', isa => U1 );

1;
