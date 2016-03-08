use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameLocals1StackItemFrameExtended;
use Moo;

# ABSTRACT: same_locals_1_stack_item_frame_extended

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has frame_type             => ( is => 'ro', isa => U1 );
has offset_delta           => ( is => 'ro', isa => U2 );
has verification_type_info => ( is => 'ro', isa => ArrayRef[U1] );

1;
