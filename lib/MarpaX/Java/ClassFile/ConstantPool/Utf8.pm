use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::Utf8;

# ABSTRACT: Java .class's CONSTANT_Utf8_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Standard qw/Str/;
use Types::Common::Numeric qw/PositiveOrZeroInt/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has length         => ( is => 'ro', isa => PositiveOrZeroInt, required => 1 );
has computed_value => ( is => 'ro', isa => Str,               required => 1 );

1;
