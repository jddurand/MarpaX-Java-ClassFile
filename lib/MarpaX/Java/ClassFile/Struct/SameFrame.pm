use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameFrame;
use MarpaX::Java::ClassFile::Util::FrameTypeStringification qw/frameTypeStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/frame_type/],
  '""' => [
           [ sub { 'Frame type'   } => sub { $_[0]->frameTypeStringificator($_[0]->frame_type) } ]
          ];

# ABSTRACT: same_frame

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has frame_type => ( is => 'ro', required => 1, isa => U1 );

1;
