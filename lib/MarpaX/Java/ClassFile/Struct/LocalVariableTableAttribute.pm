use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariableTableAttribute;
use Moo;

# ABSTRACT: Exceptions_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index        => ( is => 'ro', isa => U2 );
has attribute_length            => ( is => 'ro', isa => U4 );
has local_variable_table_length => ( is => 'ro', isa => U2 );
has local_variable_table        => ( is => 'ro', isa => ArrayRef[LocalVariableTable] );

1;
