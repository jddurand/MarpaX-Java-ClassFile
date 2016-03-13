use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Path;
use Moo;

# ABSTRACT: path

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has type_path_kind      => ( is => 'ro', isa => U1 );
has type_argument_index => ( is => 'ro', isa => U1 );

1;
