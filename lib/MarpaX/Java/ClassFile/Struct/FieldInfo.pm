use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::FieldInfo;
use Moo;

# ABSTRACT: field_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 AttributeInfo/;
use Types::Standard qw/ArrayRef/;

has access_flags     => ( is => 'ro', isa => U2 );
has name_index       => ( is => 'ro', isa => U2 );
has descriptor_index => ( is => 'ro', isa => U2 );
has attributes_count => ( is => 'ro', isa => U2 );
has attributes       => ( is => 'ro', isa => ArrayRef[AttributeInfo] );

1;
