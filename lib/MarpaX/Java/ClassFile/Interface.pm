use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Interface;

# ABSTRACT: Java .class's interface object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric -all;
use Types::Standard qw/InstanceOf/;

has classFile => ( is => 'ro', isa => InstanceOf['MarpaX::Java::ClassFile'], required => 1, weak_ref => 1 ); # weak ref
has u2        => ( is => 'ro', isa => PositiveOrZeroInt, required => 1 );

1;
