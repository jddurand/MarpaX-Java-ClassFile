use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameLocals1StackItemFrameExtended;
use MarpaX::Java::ClassFile::Util::FrameTypeStringification qw/frameTypeStringificator/;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Frame type'   } => sub { $_[0]->frameTypeStringificator($_[0]->frame_type) } ],
           [ sub { 'Offset delta' } => sub { $_[0]->offset_delta } ],
           [ sub { 'Stack'        } => sub { $_[0]->arrayStringificator($_[0]->stack) } ]
          ];

# ABSTRACT: same_locals_1_stack_item_frame_extended

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 VerificationTypeInfo/;
use Types::Standard qw/ArrayRef/;

has frame_type   => ( is => 'ro', required => 1, isa => U1 );
has offset_delta => ( is => 'ro', required => 1, isa => U2 );
has stack        => ( is => 'ro', required => 1, isa => ArrayRef[VerificationTypeInfo] );

1;
