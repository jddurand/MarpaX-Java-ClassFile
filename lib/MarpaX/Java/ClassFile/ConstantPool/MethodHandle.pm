use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::MethodHandle;

# ABSTRACT: Java .class's CONSTANT_MethodHandle_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveInt/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has reference_kind  => ( is => 'ro', isa => PositiveInt, required => 1 );
has reference_index => ( is => 'ro', isa => PositiveInt, required => 1 );

1;
