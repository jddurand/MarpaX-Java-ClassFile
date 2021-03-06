use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeVisibleTypeAnnotationsAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool attribute_name_index attribute_length num_annotations annotations/],
  '""' => [
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
