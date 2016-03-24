use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypePath;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/path_length path/],
  '""' => [
           [ sub { 'Path count' } => sub { $_[0]->path_length } ],
           [ sub { 'Path'       } => sub { $_[0]->arrayStringificator($_[0]->path) } ]
          ];

# ABSTRACT: type_path

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 Path/;
use Types::Standard qw/ArrayRef/;

has path_length  => ( is => 'ro', required => 1, isa => U1 );
has path         => ( is => 'ro', required => 1, isa => ArrayRef[Path] );

1;
