use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypeArgumentTarget;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: localvar_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;

has offset              => ( is => 'ro', required => 1, isa => U2 );
has type_argument_index => ( is => 'ro', required => 1, isa => U1 );

1;
