use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::String;

# ABSTRACT: Java .class's CONSTANT_String_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveInt/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has string_index => ( is => 'ro', isa => PositiveInt, required => 1 );

1;
