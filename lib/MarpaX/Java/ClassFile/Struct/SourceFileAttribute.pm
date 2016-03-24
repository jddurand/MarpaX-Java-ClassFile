use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SourceFileAttribute;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool attribute_name_index attribute_length sourcefile_index/],
  '""' => [
           [ sub { 'Source file#' . $_[0]->sourcefile_index } => sub { $_[0]->_constant_pool->[$_[0]->sourcefile_index] } ]
          ];

# ABSTRACT: SourceFile_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;
use Types::Standard qw/ArrayRef/;

has _constant_pool       => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index => ( is => 'ro', required => 1, isa => U2 );
has attribute_length     => ( is => 'ro', required => 1, isa => U4 );
has sourcefile_index     => ( is => 'ro', required => 1, isa => U2 );

1;
