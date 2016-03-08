use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::CodeAttribute;
use Moo;

# ABSTRACT: Code_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index    => ( is => 'ro', isa => U2 );
has attribute_length        => ( is => 'ro', isa => U4 );
has max_stack               => ( is => 'ro', isa => U2 );
has max_locals              => ( is => 'ro', isa => U2 );
has code_length             => ( is => 'ro', isa => U4 );
has code                    => ( is => 'ro', isa => ArrayRef[U1] );
has exception_table_length  => ( is => 'ro', isa => U2 );
has exception_table         => ( is => 'ro', isa => ArrayRef[ExceptionTable] );
has attributes_count        => ( is => 'ro', isa => U2 );
has attributes              => ( is => 'ro', isa => ArrayRef[AttributeInfo] );

1;
