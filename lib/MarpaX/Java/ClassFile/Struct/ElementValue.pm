use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ElementValue;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'value' } => sub { $_[0]->value } ]
          ];

# ABSTRACT: element value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 ConstValueIndex EnumConstValue ClassInfoIndex Annotation ArrayValue/;

has tag   => ( is => 'ro', required => 1, isa => U1 );
has value => ( is => 'ro', required => 1, isa => ConstValueIndex|EnumConstValue|ClassInfoIndex|Annotation|ArrayValue );

1;
