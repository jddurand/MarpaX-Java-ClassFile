use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ExceptionsAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: Exceptions_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index   => ( is => 'ro', required => 1, isa => U2 );
has attribute_length       => ( is => 'ro', required => 1, isa => U4 );
has number_of_exceptions   => ( is => 'ro', required => 1, isa => U2 );
has exception_index_table  => ( is => 'ro', required => 1, isa => ArrayRef[U2] );

1;
