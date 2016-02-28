use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::InterfacesArray;

# ABSTRACT: Java .class's interfaces parsing

# VERSION

# AUTHORITY

use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use Types::Common::Numeric -all;
use Types::Standard -all;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::InterfacesArray is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('u2$' => \&_u2Callback);

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ------------
# Our thingies
# ------------
has size    => (is => 'ro', isa => PositiveOrZeroInt, required => 1);
has _nbDone => (is => 'rw', isa => PositiveOrZeroInt, default => sub { 0 });

sub BUILD {
  my ($self) = @_;
  $self->debugf('Starting');
  $self->ast([]) if (! $self->size)
}

# ---------------
# Callback callbacks
# ---------------
sub _u2Callback {
  my ($self) = @_;
  $self->_nbDone($self->_nbDone + 1);
  $self->debugf('Completed');
  $self->max($self->pos) if ($self->_nbDone >= $self->size);
}

with qw/MarpaX::Java::ClassFile::Common/;

# ------------------
# Role modifications
# ------------------
around whoami => sub {
  my ($orig, $self, @args) = @_;

  my $whoami = $self->$orig(@args);
  #
  # Append the array indice, eventually
  #
  $self->_nbDone ? join('', $whoami, '[', $self->_nbDone, '/', $self->size, ']') : $whoami
};

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'u2$' = completed u2

interfacesArray ::= u2*  action => [values]
