use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ObjectVariableInfo;
use Moo;

# ABSTRACT: Object_variable_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag         => ( is => 'ro', isa => U1 );
has cpool_index => ( is => 'ro', isa => U2 );

1;
