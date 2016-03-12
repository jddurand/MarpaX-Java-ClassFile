use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::CodeAttribute;
use Moo;

# ABSTRACT: Code_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;
use Types::Encodings qw/Bytes/;

has attribute_name_index    => ( is => 'ro', required => 1, isa => U2 );
has attribute_length        => ( is => 'ro', required => 1, isa => U4 );
has max_stack               => ( is => 'ro', required => 1, isa => U2 );
has max_locals              => ( is => 'ro', required => 1, isa => U2 );
has code_length             => ( is => 'ro', required => 1, isa => U4 );
has code                    => ( is => 'ro', required => 1, isa => ArrayRef[OpCode] );
has exception_table_length  => ( is => 'ro', required => 1, isa => U2 );
has exception_table         => ( is => 'ro', required => 1, isa => ArrayRef[ExceptionTable] );
has attributes_count        => ( is => 'ro', required => 1, isa => U2 );
has attributes              => ( is => 'ro', required => 1, isa => ArrayRef[AttributeInfo] );

1;
