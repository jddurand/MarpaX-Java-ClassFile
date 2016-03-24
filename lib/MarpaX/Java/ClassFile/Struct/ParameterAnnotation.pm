use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ParameterAnnotation;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/num_annotations annotations/],
  '""' => [
           [ sub { 'Annotations count' } => sub { $_[0]->num_annotations } ],
           [ sub { 'Annotations'       } => sub { $_[0]->arrayStringificator($_[0]->annotations) } ]
          ];

# ABSTRACT: parameter annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 Annotation/;
use Types::Standard qw/ArrayRef/;

has num_annotations => ( is => 'ro', required => 1, isa => U2 );
has annotations     => ( is => 'ro', required => 1, isa => ArrayRef[Annotation] );

1;
