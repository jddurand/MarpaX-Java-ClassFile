use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::Fieldref;

# ABSTRACT: Java .class's CONSTANT_Fieldref_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveInt/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has class_index         => ( is => 'ro', isa => PositiveInt, required => 1 );
has name_and_type_index => ( is => 'ro', isa => PositiveInt, required => 1 );

1;
