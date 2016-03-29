use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantFloatInfo;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_perlvalue tag bytes/],
  '""' => [
           [ sub { $_[0]->_perlvalue->bstr } ]
          ];

# ABSTRACT: CONSTANT_Float_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;
use Types::Encodings qw/Bytes/;
use Types::Standard qw/InstanceOf/;

has _perlvalue   => ( is => 'ro', required => 1, isa => InstanceOf['Math::BigFloat'] );
has tag          => ( is => 'ro', required => 1, isa => U1 );
has bytes        => ( is => 'ro', required => 1, isa => Bytes );

1;
