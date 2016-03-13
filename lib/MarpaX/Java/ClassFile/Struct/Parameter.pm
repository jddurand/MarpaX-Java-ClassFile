use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Parameter;
use Moo;

# ABSTRACT: parameter

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has name_index   => ( is => 'ro', isa => U2 );
has access_flags => ( is => 'ro', isa => U2 );

1;
