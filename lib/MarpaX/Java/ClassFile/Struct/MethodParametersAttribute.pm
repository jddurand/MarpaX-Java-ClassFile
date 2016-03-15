use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::MethodParametersAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: MethodParameters_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 U4 Parameter/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has parameters_count      => ( is => 'ro', required => 1, isa => U1 );
has parameters            => ( is => 'ro', required => 1, isa => ArrayRef[Parameter] );

1;
