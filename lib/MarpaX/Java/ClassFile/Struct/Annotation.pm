use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Annotation;
use Moo;

# ABSTRACT: annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has type_index              => ( is => 'ro', isa => U2 );
has num_element_value_pairs => ( is => 'ro', isa => U2 );
has element_value_pairs     => ( is => 'ro', isa => ArrayRef[ElementValuePair] );

1;
