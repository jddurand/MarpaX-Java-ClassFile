use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Actions;
use Bit::Vector;

sub new {
  $MarpaX::Java::ClassFile::Common::SELF
}

sub u1 {
  unpack('C', $_[1])
}

sub u2 {
  unpack('n', $_[1])
}
sub u4 { # Bit::Vector for quadratic unpack
  #
  # 33 = 8 * 4 + 1, where +1 to make sure new_Dec never returns a signed value
  #
  my @bytes = split('', $_[1]);
  my $vector = Bit::Vector->new_Dec(33, unpack('C', $bytes[0]));
  foreach (1..3) {
    $vector->Move_Left(8);
    $vector->Or($vector, Bit::Vector->new_Dec(33, unpack('C', $bytes[$_])))
  }
  $vector->to_Dec()
}

1;
