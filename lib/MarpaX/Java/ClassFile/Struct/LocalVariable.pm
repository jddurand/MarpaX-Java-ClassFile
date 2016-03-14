use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariable;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: local variable

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has start_pc         => ( is => 'ro', required => 1, isa => U2 );
has length           => ( is => 'ro', required => 1, isa => U2 );
has name_index       => ( is => 'ro', required => 1, isa => U2 );
has descriptor_index => ( is => 'ro', required => 1, isa => U2 );
has index            => ( is => 'ro', required => 1, isa => U2 );

1;
