use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;

# ABSTRACT: Java .class parsing

# VERSION

# AUTHORITY

use Carp qw/croak/;
use MarpaX::Java::ClassFile::BNF::ClassFile;

sub parse {
  my ($class, $filename) = @_;

  open(my $fh, '<', $filename) || croak "Cannot open $filename, $!";
  binmode($fh);
  my $input = do { local $/; <$fh>};
  close($fh) || warn "Cannot close $filename, $!";

  MarpaX::Java::ClassFile::BNF::ClassFile->new(inputRef => \$input)->ast
}

1;
