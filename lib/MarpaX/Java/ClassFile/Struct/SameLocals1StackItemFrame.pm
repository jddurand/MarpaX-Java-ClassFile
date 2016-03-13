use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameLocals1StackItemFrame;
use Moo;

# ABSTRACT: same_locals_1_stack_item_frame

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 VerificationTypeInfo/;
use Types::Standard qw/ArrayRef/;

has frame_type => ( is => 'ro', required => 1, isa => U1 );
has stack      => ( is => 'ro', required => 1, isa => ArrayRef[VerificationTypeInfo] );

1;
