use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeVisibleTypeAnnotationsAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Attribute name#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           [ sub { 'Type annotations count'                        } => sub { $_[0]->num_annotations } ],
           [ sub { 'Type annotations'                              } => sub { $_[0]->arrayStringificator($_[0]->annotations) } ]
          ];

# ABSTRACT: RuntimeVisibleTypeAnnotations_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 U4 TypeAnnotation/;
use Types::Standard qw/ArrayRef/;

has _constant_pool        => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has num_annotations       => ( is => 'ro', required => 1, isa => U1 );
has annotations           => ( is => 'ro', required => 1, isa => ArrayRef[TypeAnnotation] );

1;
