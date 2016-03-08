use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ParameterAnnotation;
use Moo;

# ABSTRACT: parameter annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has num_annotations => ( is => 'ro', isa => U2 );
has annotations     => ( is => 'ro', isa => ArrayRef[Annotation] );

1;
