use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Parameter;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: parameter

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has name_index   => ( is => 'ro', required => 1, isa => U2 );
has access_flags => ( is => 'ro', required => 1, isa => U2 );

1;
