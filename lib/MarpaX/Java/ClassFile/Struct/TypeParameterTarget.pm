use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypeParameterTarget;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/type_parameter_index/],
  '""' => [
           [ sub { 'Type parameter index' } => sub { $_[0]->type_parameter_index } ]
          ];

# ABSTRACT: type_parameter_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has type_parameter_index  => ( is => 'ro', required => 1, isa => U1 );

1;
