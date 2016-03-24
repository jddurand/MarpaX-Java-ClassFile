use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::MethodInfo;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Util::AccessFlagsStringification qw/accessFlagsStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool access_flags name_index descriptor_index attributes_count attributes/],
  '""' => [
           [ sub { 'Name#' . $_[0]->name_index             } => sub { $_[0]->_constant_pool->[$_[0]->name_index] } ],
           [ sub { 'Descriptor#' . $_[0]->descriptor_index } => sub { $_[0]->_constant_pool->[$_[0]->descriptor_index] } ],
           [ sub { 'Attributes count'                      } => sub { $_[0]->attributes_count } ],
           [ sub { 'Attributes'                            } => sub { $_[0]->arrayStringificator($_[0]->attributes) } ]
          ];

# ABSTRACT: method_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 AttributeInfo/;
use Types::Standard qw/ArrayRef/;

has _constant_pool   => ( is => 'rw', required => 1, isa => ArrayRef);
has access_flags     => ( is => 'ro', required => 1, isa => U2 );
has name_index       => ( is => 'ro', required => 1, isa => U2 );
has descriptor_index => ( is => 'ro', required => 1, isa => U2 );
has attributes_count => ( is => 'ro', required => 1, isa => U2 );
has attributes       => ( is => 'ro', required => 1, isa => ArrayRef[AttributeInfo] );

1;
