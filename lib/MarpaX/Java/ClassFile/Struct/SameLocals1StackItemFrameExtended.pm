use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameLocals1StackItemFrameExtended;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: same_locals_1_stack_item_frame_extended

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 VerificationTypeInfo/;
use Types::Standard qw/ArrayRef/;

has frame_type   => ( is => 'ro', required => 1, isa => U1 );
has offset_delta => ( is => 'ro', required => 1, isa => U2 );
has stack        => ( is => 'ro', required => 1, isa => ArrayRef[VerificationTypeInfo] );

1;
