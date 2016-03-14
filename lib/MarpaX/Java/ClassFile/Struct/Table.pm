use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Table;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: table

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has start_pc => ( is => 'ro', required => 1, isa => U2 );
has length   => ( is => 'ro', required => 1, isa => U2 );
has index    => ( is => 'ro', required => 1, isa => U2 );

1;
