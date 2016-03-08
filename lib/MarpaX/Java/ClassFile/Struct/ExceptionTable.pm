use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ExceptionTable;
use Moo;

# ABSTRACT: exception_table

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has start_pc   => ( is => 'ro', isa => U2 );
has end_pc     => ( is => 'ro', isa => U2 );
has handler_pc => ( is => 'ro', isa => U2 );
has catch_type => ( is => 'ro', isa => U2 );

1;
