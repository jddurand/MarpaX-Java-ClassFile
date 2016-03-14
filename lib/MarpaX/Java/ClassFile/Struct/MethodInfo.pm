use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::MethodInfo;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: method_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 AttributeInfo/;
use Types::Standard qw/ArrayRef/;

has access_flags     => ( is => 'ro', required => 1, isa => U2 );
has name_index       => ( is => 'ro', required => 1, isa => U2 );
has descriptor_index => ( is => 'ro', required => 1, isa => U2 );
has attributes_count => ( is => 'ro', required => 1, isa => U2 );
has attributes       => ( is => 'ro', required => 1, isa => ArrayRef[AttributeInfo] );

1;
