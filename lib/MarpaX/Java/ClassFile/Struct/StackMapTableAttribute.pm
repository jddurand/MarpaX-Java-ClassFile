use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::StackMapTableAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: StackMapTable_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 StackMapFrame/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index    => ( is => 'ro', required => 1, isa => U2 );
has attribute_length        => ( is => 'ro', required => 1, isa => U4 );
has number_of_entries       => ( is => 'ro', required => 1, isa => U2 );
has entries                 => ( is => 'ro', required => 1, isa => ArrayRef[StackMapFrame] );

1;
