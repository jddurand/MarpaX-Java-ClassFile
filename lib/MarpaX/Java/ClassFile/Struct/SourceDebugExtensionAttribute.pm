use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SourceDebugExtensionAttribute;
use Moo;

# ABSTRACT: SourceDebugExtension_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index => ( is => 'ro', isa => U2 );
has attribute_length     => ( is => 'ro', isa => U4 );
has debug_extension      => ( is => 'ro', isa => ArrayRef[U1] );

1;
