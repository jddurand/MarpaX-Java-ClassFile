use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::CatchTarget;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/exception_table_index/],
  '""' => [
           [ sub { 'Exception table index' } => sub { $_[0]->exception_table_index } ]
          ];

# ABSTRACT: localvar_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has exception_table_index => ( is => 'ro', required => 1, isa => U2 );

1;
