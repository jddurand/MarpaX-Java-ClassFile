use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypePath;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: type_path

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 Path/;
use Types::Standard qw/ArrayRef/;

has path_length  => ( is => 'ro', required => 1, isa => U1 );
has path         => ( is => 'ro', required => 1, isa => ArrayRef[Path] );

1;
