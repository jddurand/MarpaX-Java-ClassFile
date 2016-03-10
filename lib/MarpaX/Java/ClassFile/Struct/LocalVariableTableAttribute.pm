use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariableTableAttribute;
use Moo;

# ABSTRACT: Exceptions_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index        => ( is => 'ro', required => 1, isa => U2 );
has attribute_length            => ( is => 'ro', required => 1, isa => U4 );
has local_variable_table_length => ( is => 'ro', required => 1, isa => U2 );
has local_variable_table        => ( is => 'ro', required => 1, isa => ArrayRef[LocalVariable] );

1;
