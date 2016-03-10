use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::NullVariableInfo;
use Moo;

# ABSTRACT: Null_variable_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag => ( is => 'ro', required => 1, isa => U1 );

1;
