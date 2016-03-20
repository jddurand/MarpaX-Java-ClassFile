use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;
use Moo;

use Types::Standard qw/Str InstanceOf Bool/;

# ABSTRACT: Java .class parsing

# VERSION

# AUTHORITY

has filename => ( is => 'ro',  isa => Str, required => 1);
has ast      => ( is => 'ro', isa => InstanceOf['MarpaX::Java::ClassFile::Struct::ClassFile'], lazy => 1, builder => 1);

use Carp qw/croak/;
require MarpaX::Java::ClassFile::BNF::ClassFile;
require MarpaX::Java::ClassFile::Struct::ClassFile;

sub _build_ast {
  my ($self) = @_;

  $self->_logger->debugf('Opening %s', $self->filename);
  open(my $fh, '<', $self->filename) || do {
    $self->fatalf('Cannot open %s, %s', $self->filename, $!);
    croak "Cannot open " . $self->filename . ", $!"
  };

  $self->_logger->debugf('Setting %s in binary mode', $self->filename);
  binmode($fh) || do {
    $self->fatalf('Failed to set binary mode on %s, %s', $self->filename, $!);
    croak "Failed to set binary mode on " . $self->filename . ", $!"
  };

  $self->_logger->debugf('Reading %s', $self->filename);
  my $input = do { local $/; <$fh>};

  $self->_logger->debugf('Closing %s', $self->filename);
  close($fh) || do {
    $self->warnf('Failed to close %s, %s', $self->filename, $!);
    croak "Failed to close " . $self->filename . ", $!"
  };

  $self->_logger->debugf('Parsing %s', $self->filename);
  MarpaX::Java::ClassFile::BNF::ClassFile->new(inputRef => \$input)->ast
}

with 'MooX::Role::Logger';

1;
