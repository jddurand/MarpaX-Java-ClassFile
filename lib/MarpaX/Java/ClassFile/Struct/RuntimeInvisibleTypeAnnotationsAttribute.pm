use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeInvisibleTypeAnnotationsAttribute;
use Moo;

# ABSTRACT: RuntimeInvisibleTypeAnnotations_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 TypeAnnotation/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index  => ( is => 'ro', isa => U2 );
has attribute_length      => ( is => 'ro', isa => U4 );
has num_annotations       => ( is => 'ro', isa => U2 );
has annotations           => ( is => 'ro', isa => ArrayRef[TypeAnnotation] );

1;
