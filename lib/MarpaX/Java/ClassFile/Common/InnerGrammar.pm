use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Common::InnerGrammar;

# ABSTRACT: Parsing engine role for .class file parsing - inner grammar

# VERSION

# AUTHORITY

use Moo::Role;

use Types::Common::Numeric -all;
use Types::Standard -all;

has size    => (is => 'ro', isa => PositiveOrZeroInt, required => 1);
has _nbDone => (is => 'rw', isa => PositiveOrZeroInt, default => sub { 0 });

# ------------
# Our thingies
# ------------

sub BUILD {
  my ($self) = @_;
  $self->ast([]) if (! $self->size)
}

with qw/MarpaX::Java::ClassFile::Common/;

# ------------------
# Role modifications
# ------------------
around whoami => sub {
  my ($orig, $self, @args) = @_;

  my $whoami = $self->$orig(@args);
  my $size   = $self->size;
  my $i      = $self->_nbDone;

  ++$i if ($i < $size);
  #
  # Append the array indice
  #
  "${whoami}[${i}/${size}]"
};

1;
