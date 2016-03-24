use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeVisibleParameterAnnotationsAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool attribute_name_index attribute_length num_parameters parameter_annotations/],
  '""' => [
           [ sub { 'Parameter annotations count'                    } => sub { $_[0]->num_parameters } ],
           [ sub { 'Parameter annotations'                          } => sub { $_[0]->arrayStringificator($_[0]->parameter_annotations) } ]
          ];

# ABSTRACT: RuntimeVisibleParameterAnnotations_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 U4 ParameterAnnotation/;
use Types::Standard qw/ArrayRef/;

has _constant_pool        => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has num_parameters        => ( is => 'ro', required => 1, isa => U1 );
has parameter_annotations => ( is => 'ro', required => 1, isa => ArrayRef[ParameterAnnotation] );

1;
