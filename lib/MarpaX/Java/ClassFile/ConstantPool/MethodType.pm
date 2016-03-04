use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::MethodType;

# ABSTRACT: Java .class's CONSTANT_MethodType_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveInt/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has descriptor_index => ( is => 'ro', isa => PositiveInt, required => 1 );

1;
