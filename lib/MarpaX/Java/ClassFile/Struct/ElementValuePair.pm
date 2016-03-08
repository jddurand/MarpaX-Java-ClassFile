use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ElementValuePair;
use Moo;

# ABSTRACT: element value pair

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has element_name_index => ( is => 'ro', isa => U2 );
has value              => ( is => 'ro', isa => ElementValue );

1;
