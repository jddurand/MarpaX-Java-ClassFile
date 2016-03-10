use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LineNumberTableAttribute;
use Moo;

# ABSTRACT: LineNumberTable_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index     => ( is => 'ro', isa => U2 );
has attribute_length         => ( is => 'ro', isa => U4 );
has line_number_table_length => ( is => 'ro', isa => U2 );
has line_number_table        => ( is => 'ro', isa => ArrayRef[LineNumber] );

1;
