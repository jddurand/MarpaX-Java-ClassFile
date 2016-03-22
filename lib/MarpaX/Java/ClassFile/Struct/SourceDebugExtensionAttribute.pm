use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SourceDebugExtensionAttribute;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Attribute name#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           #
           # (I believe it) can be undef
           #
           [ sub { 'Debug extension'                               } => sub { $_[0]->debug_extension // '' } ]
          ];

# ABSTRACT: SourceDebugExtension_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 U4/;
use Types::Standard qw/ArrayRef Str Undef/;

has _constant_pool       => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index => ( is => 'ro', required => 1, isa => U2 );
has attribute_length     => ( is => 'ro', required => 1, isa => U4 );
has debug_extension      => ( is => 'ro', required => 1, isa => Str|Undef );

1;
