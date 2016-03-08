use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SupertypeTarget;
use Moo;

# ABSTRACT: supertype_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has supertype_index  => ( is => 'ro', isa => U2 );

1;
