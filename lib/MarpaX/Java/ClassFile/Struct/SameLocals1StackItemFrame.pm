use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameLocals1StackItemFrame;
use MarpaX::Java::ClassFile::Util::FrameTypeStringification qw/frameTypeStringificator/;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/frame_type stack/],
  '""' => [
           [ sub { 'Frame type' } => sub { $_[0]->frameTypeStringificator($_[0]->frame_type) } ],
           [ sub { 'Stack '     } => sub { $_[0]->arrayStringificator($_[0]->stack) } ]
          ];

# ABSTRACT: same_locals_1_stack_item_frame

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 VerificationTypeInfo/;
use Types::Standard qw/ArrayRef/;

has frame_type => ( is => 'ro', required => 1, isa => U1 );
has stack      => ( is => 'ro', required => 1, isa => ArrayRef[VerificationTypeInfo] );

1;
