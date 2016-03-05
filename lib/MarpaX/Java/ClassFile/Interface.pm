use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Interface;

# ABSTRACT: Java .class's interface object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric -all;

has u2 => ( is => 'ro', isa => PositiveOrZeroInt, required => 1 );

1;
