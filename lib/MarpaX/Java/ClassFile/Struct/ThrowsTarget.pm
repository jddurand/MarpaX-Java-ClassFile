use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ThrowsTarget;
use Moo;

# ABSTRACT: throws_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has throws_type_index  => ( is => 'ro', isa => U2 );

1;