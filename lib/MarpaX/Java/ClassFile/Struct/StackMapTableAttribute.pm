use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::StackMapTableAttribute;
use Moo;

# ABSTRACT: StackMapTable_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index    => ( is => 'ro', isa => U2 );
has attribute_length        => ( is => 'ro', isa => U4 );
has number_of_entries       => ( is => 'ro', isa => U2 );
has entries                 => ( is => 'ro', isa => ArrayRef[StackMapFrame] );

1;
