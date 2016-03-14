use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypeParameterBoundTarget;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: type_parameter_bound_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has type_parameter_index => ( is => 'ro', required => 1, isa => U1 );
has bound_index          => ( is => 'ro', required => 1, isa => U1 );

1;
