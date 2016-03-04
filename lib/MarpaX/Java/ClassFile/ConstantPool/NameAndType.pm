use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::NameAndType;

# ABSTRACT: Java .class's CONSTANT_NameAndType_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveInt/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has name_index       => ( is => 'ro', isa => PositiveInt, required => 1 );
has descriptor_index => ( is => 'ro', isa => PositiveInt, required => 1 );

1;
