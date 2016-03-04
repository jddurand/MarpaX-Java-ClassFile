use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::Integer;

# ABSTRACT: Java .class's CONSTANT_Integer_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Standard qw/Int/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has computed_value => ( is => 'ro', isa => Int, required => 1 );

1;
