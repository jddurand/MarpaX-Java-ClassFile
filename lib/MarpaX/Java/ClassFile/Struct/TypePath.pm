use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypePath;
use Moo;

# ABSTRACT: type_path

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has path_length  => ( is => 'ro', isa => U1 );
has path         => ( is => 'ro', isa => ArrayRef[Path] );

1;
