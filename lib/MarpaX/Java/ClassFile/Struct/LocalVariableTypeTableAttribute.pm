use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariableTypeTableAttribute;
use Moo;

# ABSTRACT: LocalVariableTypeTable_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 LocalVariableType/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index             => ( is => 'ro', required => 1, isa => U2 );
has attribute_length                 => ( is => 'ro', required => 1, isa => U4 );
has local_variable_type_table_length => ( is => 'ro', required => 1, isa => U2 );
has local_variable_type_table        => ( is => 'ro', required => 1, isa => ArrayRef[LocalVariableType] );

1;
