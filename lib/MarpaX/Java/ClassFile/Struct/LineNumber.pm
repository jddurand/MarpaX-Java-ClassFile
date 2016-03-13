use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LineNumber;
use Moo;

# ABSTRACT: line and number

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;

has start_pc    => ( is => 'ro', required => 1, isa => U2 );
has line_number => ( is => 'ro', required => 1, isa => U4 );

1;
