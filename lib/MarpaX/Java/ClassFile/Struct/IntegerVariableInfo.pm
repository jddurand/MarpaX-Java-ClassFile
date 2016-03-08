use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::IntegerVariableInfo;
use Moo;

# ABSTRACT: Integer_variable_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag => ( is => 'ro', isa => U1 );

1;
