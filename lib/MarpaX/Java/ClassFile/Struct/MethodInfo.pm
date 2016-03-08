use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::MethodInfo;
use Moo;

# ABSTRACT: method_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has access_flags     => ( is => 'ro', isa => U2 );
has name_index       => ( is => 'ro', isa => U2 );
has descriptor_index => ( is => 'ro', isa => U2 );
has attributes_count => ( is => 'ro', isa => U2 );
has attributes       => ( is => 'ro', isa => ArrayRef[AttributeInfo] );

1;
