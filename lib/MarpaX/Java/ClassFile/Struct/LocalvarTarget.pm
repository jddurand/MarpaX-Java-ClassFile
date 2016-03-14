use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalvarTarget;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: localvar_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 Table/;
use Types::Standard qw/ArrayRef/;

has table_length => ( is => 'ro', required => 1, isa => U2 );
has table        => ( is => 'ro', required => 1, isa => ArrayRef[Table] );

1;
