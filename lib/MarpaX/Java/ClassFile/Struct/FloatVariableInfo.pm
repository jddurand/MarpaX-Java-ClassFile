use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::FloatVariableInfo;
use Moo;

# ABSTRACT: Float_variable_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag => ( is => 'ro', isa => U1 );

1;
