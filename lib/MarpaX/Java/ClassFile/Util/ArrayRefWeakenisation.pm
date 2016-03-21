use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Util::ArrayRefWeakenisation;
use Carp qw/croak/;
use Exporter 'import'; # gives you Exporter's import() method directly
use Scalar::Util qw/weaken/;
our @EXPORT_OK = qw/arrayRefWeakenisator/;

# ABSTRACT: Weakens the content of an array reference

# VERSION

# AUTHORITY

sub arrayRefWeakenisator {
  # my ($self, $arrayRef) = @_;

  map { weaken($_[1]->[$_]) } (0..$#{$_[1]})
}

1;
