use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool;

# ABSTRACT: Java .class's cp_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Standard qw/Any/;

has tag => ( is => 'ro', isa => Any, required => 1 );

1;
