use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::InvokeDynamic;

# ABSTRACT: Java .class's CONSTANT_InvokeDynamic_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveInt PositiveOrZeroInt/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has bootstrap_method_attr_index => ( is => 'ro', isa => PositiveOrZeroInt, required => 1 );
has name_and_type_index         => ( is => 'ro', isa => PositiveInt,       required => 1 );

1;
