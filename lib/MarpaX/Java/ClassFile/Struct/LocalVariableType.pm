use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariableType;
use Moo;

# ABSTRACT: local variable type

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has start_pc         => ( is => 'ro', required => 1, isa => U2 );
has length           => ( is => 'ro', required => 1, isa => U2 );
has name_index       => ( is => 'ro', required => 1, isa => U2 );
has signature_index  => ( is => 'ro', required => 1, isa => U2 );
has index            => ( is => 'ro', required => 1, isa => U2 );

1;
