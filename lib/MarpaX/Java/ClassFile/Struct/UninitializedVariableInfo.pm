use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::UninitializedVariableInfo;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: Uninitialized_variable_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;

has tag    => ( is => 'ro', required => 1, isa => U1 );
has offset => ( is => 'ro', required => 1, isa => U2 );

1;
