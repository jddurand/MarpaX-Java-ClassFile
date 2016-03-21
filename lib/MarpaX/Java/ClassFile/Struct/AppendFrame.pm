use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::AppendFrame;
use MarpaX::Java::ClassFile::Util::FrameTypeStringification qw/frameTypeStringificator/;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'frame_type  ' } => sub { $_[0]->frameTypeStringificator($_[0]->frame_type) } ],
           [ sub { 'offset_delta' } => sub { $_[0]->offset_delta } ],
           [ sub { 'Locals count' } => sub { $_[0]->frame_type - 251 } ],
           [ sub { 'Locals      ' } => sub { $_[0]->arrayStringificator($_[0]->locals) } ]
          ];

# ABSTRACT: append_frame

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 VerificationTypeInfo/;
use Types::Standard qw/ArrayRef/;

has frame_type   => ( is => 'ro', required => 1, isa => U1 );
has offset_delta => ( is => 'ro', required => 1, isa => U2 );
has locals       => ( is => 'ro', required => 1, isa => ArrayRef[VerificationTypeInfo] );

1;
