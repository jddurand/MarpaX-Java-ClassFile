use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ThrowsTarget;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: throws_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has throws_type_index  => ( is => 'ro', required => 1, isa => U2 );

1;
