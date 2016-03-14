use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::FormalParameterTarget;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: formal_parameter_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has formal_parameter_index  => ( is => 'ro', required => 1, isa => U1 );

1;
