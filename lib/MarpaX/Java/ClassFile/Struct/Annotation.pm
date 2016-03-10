use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Annotation;
use Moo;

# ABSTRACT: annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has type_index              => ( is => 'ro', required => 1, isa => U2 );
has num_element_value_pairs => ( is => 'ro', required => 1, isa => U2 );
has element_value_pairs     => ( is => 'ro', required => 1, isa => ArrayRef[ElementValuePair] );

1;
