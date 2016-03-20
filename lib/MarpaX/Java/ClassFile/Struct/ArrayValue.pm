use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ArrayValue;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Values count' } => sub { $_[0]->num_values } ],
           [ sub { 'Values      ' } => sub { $_[0]->arrayStringificator($_[0]->values) } ]
          ];

# ABSTRACT: constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 ElementValue/;
use Types::Standard qw/ArrayRef/;

has num_values => ( is => 'ro', required => 1, isa => U2 );
has values     => ( is => 'ro', required => 1, isa => ArrayRef[ElementValue] );

1;
