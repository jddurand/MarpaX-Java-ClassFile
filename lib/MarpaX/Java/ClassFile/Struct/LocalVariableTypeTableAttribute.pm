use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariableTypeTableAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool attribute_name_index attribute_length local_variable_type_table_length local_variable_type_table/],
  '""' => [
           [ sub { 'Local variable type count'                     } => sub { $_[0]->local_variable_type_table_length } ],
           [ sub { 'Local variable type'                           } => sub { $_[0]->arrayStringificator($_[0]->local_variable_type_table) } ]
          ];

# ABSTRACT: LocalVariableTypeTable_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 LocalVariableType/;
use Types::Standard qw/ArrayRef/;

has _constant_pool                   => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index             => ( is => 'ro', required => 1, isa => U2 );
has attribute_length                 => ( is => 'ro', required => 1, isa => U4 );
has local_variable_type_table_length => ( is => 'ro', required => 1, isa => U2 );
has local_variable_type_table        => ( is => 'ro', required => 1, isa => ArrayRef[LocalVariableType] );

1;
