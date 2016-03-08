use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameFrameExtended ;
use Moo;

# ABSTRACT: same_frame_extended

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has frame_type   => ( is => 'ro', isa => U1 );
has offset_delta => ( is => 'ro', isa => U2 );

1;