use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LineNumberTableAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool attribute_name_index attribute_length line_number_table_length line_number_table/],
  '""' => [
           [ sub { 'Line number count'                             } => sub { $_[0]->line_number_table_length } ],
           [ sub { 'Line number'                                   } => sub { $_[0]->arrayStringificator($_[0]->line_number_table) } ]
          ];

# ABSTRACT: LineNumberTable_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 LineNumber/;
use Types::Standard qw/ArrayRef/;

has _constant_pool           => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index     => ( is => 'ro', required => 1, isa => U2 );
has attribute_length         => ( is => 'ro', required => 1, isa => U4 );
has line_number_table_length => ( is => 'ro', required => 1, isa => U2 );
has line_number_table        => ( is => 'ro', required => 1, isa => ArrayRef[LineNumber] );

1;
