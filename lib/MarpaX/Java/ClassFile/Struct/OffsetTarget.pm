use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::OffsetTarget;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: localvar_target

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has offset => ( is => 'ro', required => 1, isa => U2 );

1;
