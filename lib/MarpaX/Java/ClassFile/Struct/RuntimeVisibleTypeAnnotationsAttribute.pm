use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeVisibleTypeAnnotationsAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: RuntimeVisibleTypeAnnotations_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 U4 TypeAnnotation/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has num_annotations       => ( is => 'ro', required => 1, isa => U1 );
has annotations           => ( is => 'ro', required => 1, isa => ArrayRef[TypeAnnotation] );

1;
