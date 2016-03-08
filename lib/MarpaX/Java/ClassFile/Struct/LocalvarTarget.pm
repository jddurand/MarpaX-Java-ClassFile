use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalvarTarget;
use Moo;

# ABSTRACT: localvar_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has table_length => ( is => 'ro', isa => U2 );
has table        => ( is => 'ro', isa => ArrayRef[Table] );

1;
