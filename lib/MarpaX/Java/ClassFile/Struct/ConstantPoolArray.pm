use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantPoolArray;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: Constant Pool Array

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/CpInfo/;
use Types::Standard qw/ArrayRef/;

has _array => ( is => 'ro', required => 1, isa => ArrayRef[CpInfo], default => sub { [] } );

sub get       { $_[0]->_array->[$_[1]] }
sub set       { $_[0]->_array->[$_[1]] = $_[2] }
sub elements  { @{$_[0]->_array} }
sub maxIndice { $#{$_[0]->_array} }

sub BUILDARGS {
  my ($class, @args) = @_;

  unshift @args, '_array' if (@args % 2 == 1);

  return { @args };
}

sub _stringify {
  # my ($self) = @_;

  my $maxIndice       = $_[0]->maxIndice;
  my $lengthMaxIndice = length($maxIndice);
  my @stringArray = ();
  map { push(@stringArray, sprintf('  #%-*d %s', $lengthMaxIndice, $_, $_[0]->get($_))) } grep { defined($_[0]->get($_)) } (0..$maxIndice);
  "Constant pool\n[\n" . join("\n", @stringArray) . "]"
}

1;
