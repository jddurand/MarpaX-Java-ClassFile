use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Util::FrameTypeStringification;
use Exporter 'import'; # gives you Exporter's import() method directly
our @EXPORT_OK = qw/frameTypeStringificator/;

# ABSTRACT: Returns the string describing a frame type

# VERSION

# AUTHORITY

sub frameTypeStringificator {
  # my ($self, $frame_type) = @_;

  if    (($_[1] >=   0) && ($_[1] <=  63)) { 'SAME' }
  elsif (($_[1] >=  64) && ($_[1] <= 127)) { 'SAME_LOCALS_1_STACK_ITEM' }
  elsif ( $_[1] == 247)                    { 'SAME_LOCALS_1_STACK_ITEM_EXTENDED' }
  elsif (($_[1] >= 248) && ($_[1] <= 250)) { 'CHOP' }
  elsif ( $_[1] == 251)                    { 'SAME_FRAME_EXTENDED' }
  elsif (($_[1] >= 252) && ($_[1] <= 254)) { 'APPEND' }
  elsif ( $_[1] == 255)                    { 'FULL_FRAME' }
  else                                     { 'UNMANAGED_FRAME_TYPE' }
}

1;
