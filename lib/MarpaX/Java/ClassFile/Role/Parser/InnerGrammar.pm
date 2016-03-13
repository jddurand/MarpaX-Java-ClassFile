use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Role::Parser::InnerGrammar;

# ABSTRACT: Parsing engine role for .class file parsing - inner grammar

# VERSION

# AUTHORITY

use Moo::Role;

use Types::Common::Numeric qw/PositiveOrZeroInt/;
use Types::Standard qw/Int ArrayRef/;
use MarpaX::Java::ClassFile::Util::ProductionMode qw/prod_isa/;
#
# size have this meaning:
#   0 none    output will always be []
# < 0 unknown (then caller should set max)
# > 0 fixed
#
has size          => ( is => 'ro',  prod_isa(Int),               default => sub {  0 } );
has nbDone        => ( is => 'rwp', prod_isa(PositiveOrZeroInt), default => sub {  0 } );

sub inc_nbDone {
  $_[0]->_set_nbDone($_[0]->nbDone + 1)
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

# ------------------
# Role modifications
# ------------------
has '+ast'        => ( is => 'ro',  prod_isa(ArrayRef), lazy => 1, builder => 1);

around ast => sub {
  my ($orig, $self) = @_;

  (($self->size > 0) || (($self->size < 0) && ($self->max > $self->pos))) ? $self->$orig : []
};

around manageEvents => sub {
  my ($orig, $self) = @_;

  $self->$orig;
  $self->_set_max($self->pos) if (($self->size > 0) && ($self->nbDone >= $self->size))
};

around whoami => sub {
  my ($orig, $self, @args) = @_;

  my $whoami = $self->$orig(@args);
  my $size   = $self->size;
  my $i      = $self->nbDone;

  ++$i if ($i < $size);
  "${whoami}[${i}/${size}]"
};

before _set_nbDone => sub {
  my ($self) = @_;

  $self->tracef('Entry %d/%d done', $self->nbDone + 1, $self->size)
};

1;
