use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Table;
use Moo;

# ABSTRACT: table

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has start_pc => ( is => 'ro', isa => U2 );
has length   => ( is => 'ro', isa => U2 );
has index    => ( is => 'ro', isa => U2 );

1;
