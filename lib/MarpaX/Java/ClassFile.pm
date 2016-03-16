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

  open(my $fh, '<', $self->filename) || croak "Cannot open " . $self->filename . ", $!";
  binmode($fh);
  my $input = do { local $/; <$fh>};
  close($fh) || warn "Cannot close " . $self->filename . ", $!";

  MarpaX::Java::ClassFile::BNF::ClassFile->new(inputRef => \$input)->ast
  }

sub toString { $_[0]->ast->toString }

1;
