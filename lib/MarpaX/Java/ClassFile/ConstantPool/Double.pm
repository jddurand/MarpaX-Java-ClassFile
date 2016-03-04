use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPool::Double;

# ABSTRACT: Java .class's CONSTANT_Double_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Standard qw/InstanceOf/;

extends 'MarpaX::Java::ClassFile::ConstantPool';

has computed_value => ( is => 'ro', isa => InstanceOf['Math::BigFloat'], required => 1 );

1;
