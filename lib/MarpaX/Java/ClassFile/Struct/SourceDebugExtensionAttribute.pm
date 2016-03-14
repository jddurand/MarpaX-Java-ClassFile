use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SourceDebugExtensionAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: SourceDebugExtension_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 U4/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index => ( is => 'ro', required => 1, isa => U2 );
has attribute_length     => ( is => 'ro', required => 1, isa => U4 );
has debug_extension      => ( is => 'ro', required => 1, isa => ArrayRef[U1] );

1;
