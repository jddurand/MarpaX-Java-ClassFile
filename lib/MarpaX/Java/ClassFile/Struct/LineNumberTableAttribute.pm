use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LineNumberTableAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: LineNumberTable_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 LineNumber/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index     => ( is => 'ro', required => 1, isa => U2 );
has attribute_length         => ( is => 'ro', required => 1, isa => U4 );
has line_number_table_length => ( is => 'ro', required => 1, isa => U2 );
has line_number_table        => ( is => 'ro', required => 1, isa => ArrayRef[LineNumber] );

1;
