use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalvarTarget;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Table count' } => sub { $_[0]->table_length } ],
           [ sub { 'Table'       } => sub { $_[0]->arrayStringificator($_[0]->table) } ]
          ];

# ABSTRACT: localvar_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 Table/;
use Types::Standard qw/ArrayRef/;

has table_length => ( is => 'ro', required => 1, isa => U2 );
has table        => ( is => 'ro', required => 1, isa => ArrayRef[Table] );

1;
