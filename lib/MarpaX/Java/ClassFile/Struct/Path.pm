use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Path;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/type_path_kind type_argument_index/],
  '""' => [
           [ sub { 'Type path kind'       } => sub { $_[0]->type_path_kind } ],
           [ sub { 'Type argument index'  } => sub { $_[0]->type_argument_index } ]
          ];

# ABSTRACT: path

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has type_path_kind      => ( is => 'ro', required => 1, isa => U1 );
has type_argument_index => ( is => 'ro', required => 1, isa => U1 );

1;
