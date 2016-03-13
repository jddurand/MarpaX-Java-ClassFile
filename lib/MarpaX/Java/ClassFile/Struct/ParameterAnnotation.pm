use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ParameterAnnotation;
use Moo;

# ABSTRACT: parameter annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 Annotation/;
use Types::Standard qw/ArrayRef/;

has num_annotations => ( is => 'ro', isa => U2 );
has annotations     => ( is => 'ro', isa => ArrayRef[Annotation] );

1;
