use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::BootstrapMethod;
use Moo;

# ABSTRACT: bootstrap method

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;
use Types::Standard qw/ArrayRef/;

has bootstrap_method_ref    => ( is => 'ro', isa => U2 );
has num_bootstrap_arguments => ( is => 'ro', isa => U2 );
has bootstrap_arguments     => ( is => 'ro', isa => ArrayRef[U2] );

1;
