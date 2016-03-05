use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Method;

# ABSTRACT: Java .class's method_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveOrZeroInt/;
use Types::Standard qw/ArrayRef InstanceOf/;

has access_flags     => ( is => 'ro', isa => PositiveOrZeroInt,                                          required => 1 );
has name_index       => ( is => 'ro', isa => PositiveOrZeroInt,                                          required => 1 );
has descriptor_index => ( is => 'ro', isa => PositiveOrZeroInt,                                          required => 1 );
has attributes_count => ( is => 'ro', isa => PositiveOrZeroInt,                                          required => 1 );
has attributes       => ( is => 'ro', isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Attribute']], required => 1 );

1;
