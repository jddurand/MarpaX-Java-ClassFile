use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantNameAndTypeInfo;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool tag name_index descriptor_index/],
  '""' => [
           [ sub { 'Name#' . $_[0]->name_index             } => sub { $_[0]->_constant_pool->[$_[0]->name_index] } ],
           [ sub { 'Descriptor#' . $_[0]->descriptor_index } => sub { $_[0]->_constant_pool->[$_[0]->descriptor_index] } ]
          ];

# ABSTRACT: CONSTANT_NameAndType_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool   => ( is => 'rw', required => 1, isa => ArrayRef);
has tag              => ( is => 'ro', required => 1, isa => U1 );
has name_index       => ( is => 'ro', required => 1, isa => U2 );
has descriptor_index => ( is => 'ro', required => 1, isa => U2 );

1;
