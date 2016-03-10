use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ClassInfoIndex;
use Moo;

# ABSTRACT: constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has class_info_index => ( is => 'ro', required => 1, isa => U2 );

1;
