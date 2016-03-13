use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantStringInfo;
use Moo;

# ABSTRACT: CONSTANT_String_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Standard qw/Int/;

has tag                 => ( is => 'ro', required => 1, isa => U1 );
has string_index        => ( is => 'ro', required => 1, isa => U2 );
has _value              => ( is => 'ro', required => 1, isa => Int );

1;
