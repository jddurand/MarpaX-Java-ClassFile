use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeInvisibleParameterAnnotationsAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Attribute name#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           [ sub { 'Parameter annotations count'                    } => sub { $_[0]->num_parameters } ],
           [ sub { 'Parameter annotations'                          } => sub { $_[0]->arrayStringificator($_[0]->parameter_annotations) } ]
          ];

# ABSTRACT: RuntimeInvisibleParameterAnnotations_attribute

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
