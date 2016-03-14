use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ExceptionTable;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: exception_table

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has start_pc   => ( is => 'ro', required => 1, isa => U2 );
has end_pc     => ( is => 'ro', required => 1, isa => U2 );
has handler_pc => ( is => 'ro', required => 1, isa => U2 );
has catch_type => ( is => 'ro', required => 1, isa => U2 );

1;
