use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ElementValue;
use Moo;

# ABSTRACT: element value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag   => ( is => 'ro', required => 1, isa => U1 );
has value => ( is => 'ro', required => 1, isa => ConstValueIndex|EnumConstValue|ClassInfoIndex|Annotation|ArrayValue );

1;
