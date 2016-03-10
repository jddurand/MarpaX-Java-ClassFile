use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::EnumConstValue;
use Moo;

# ABSTRACT: enum constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has type_name_index  => ( is => 'ro', required => 1, isa => U2 );
has const_name_index => ( is => 'ro', required => 1, isa => U2 );

1;
