use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::InterfacesArray;

# ABSTRACT: Java .class's interfaces parsing

# VERSION

# AUTHORITY

use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Interface;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::InterfacesArray is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('interfacesArray$' => \&_interfacesArrayCallback);

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ---------
# Callbacks
# ---------
sub _interfacesArrayCallback {
  my ($self) = @_;
  $self->nbDone($self->nbDone + 1);
  $self->debugf('Completed');
  $self->max($self->pos) if ($self->nbDone >= $self->size);
}

# ---------------
# Grammar actions
# ---------------
sub interfacesArray {
  my ($self, @u2) = @_;

  [ map { MarpaX::Java::ClassFile::Interface->new(classFile => $self->classFile, u2 => $_) } @u2 ]
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'interfacesArray$' = completed interfacesArray

interfacesArray ::= u2*  action => interfacesArray
