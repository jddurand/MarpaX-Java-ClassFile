use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Annotation;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { '#' . $_[0]->type_index }     => sub { $_[0]->_constant_pool->[$_[0]->type_index] } ],
           [ sub { 'Element value pairs count' } => sub { $_[0]->num_element_value_pairs } ],
           [ sub { 'Element value pairs      ' } => sub { $_[0]->arrayStringificator($_[0]->element_value_pairs) } ]
          ];

# ABSTRACT: annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 ElementValuePair/;
use Types::Standard qw/ArrayRef/;

has _constant_pool          => ( is => 'rw', required => 1, isa => ArrayRef);
has type_index              => ( is => 'ro', required => 1, isa => U2 );
has num_element_value_pairs => ( is => 'ro', required => 1, isa => U2 );
has element_value_pairs     => ( is => 'ro', required => 1, isa => ArrayRef[ElementValuePair] );

1;
