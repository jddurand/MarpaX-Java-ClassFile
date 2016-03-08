use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SourceFileAttribute;
use Moo;

# ABSTRACT: SourceFile_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index => ( is => 'ro', isa => U2 );
has attribute_length     => ( is => 'ro', isa => U4 );
has sourcefile_index     => ( is => 'ro', isa => U2 );

1;
