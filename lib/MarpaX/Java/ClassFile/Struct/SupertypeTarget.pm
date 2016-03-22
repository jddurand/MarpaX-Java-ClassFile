use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SupertypeTarget;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Index' } => sub { $_[0]->supertype_index } ]
          ];

# ABSTRACT: supertype_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has supertype_index  => ( is => 'ro', required => 1, isa => U2 );

1;
