use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool;

# ABSTRACT: Java .class's cp_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Standard qw/Any InstanceOf/;

has classFile => ( is => 'ro', isa => InstanceOf['MarpaX::Java::ClassFileArray'], required => 1, weak_ref => 1 ); # weak ref
has tag       => ( is => 'ro', isa => Any, required => 1 );

1;
