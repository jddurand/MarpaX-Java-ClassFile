use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ParameterAnnotation;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: parameter annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 Annotation/;
use Types::Standard qw/ArrayRef/;

has num_annotations => ( is => 'ro', required => 1, isa => U2 );
has annotations     => ( is => 'ro', required => 1, isa => ArrayRef[Annotation] );

1;
