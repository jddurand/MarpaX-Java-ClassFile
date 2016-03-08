use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::MethodParametersAttribute;
use Moo;

# ABSTRACT: MethodParameters_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index  => ( is => 'ro', isa => U2 );
has attribute_length      => ( is => 'ro', isa => U4 );
has parameters_count      => ( is => 'ro', isa => U1 );
has parameters            => ( is => 'ro', isa => ArrayRef[Parameter] => 1 );

1;
