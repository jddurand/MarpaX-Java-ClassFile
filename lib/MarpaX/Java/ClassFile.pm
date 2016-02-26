use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;
use Moo;

use Marpa::R2;
use MarpaX::Java::ClassFile::ConstantPool;
use Types::Standard -all;

extends 'MarpaX::Java::ClassFile::BNF';

my $G         = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf(do { local $/; <DATA> })});
my %CALLBACKS = ('constant_pool_count$' => \&_constant_pool_count);

has grammar   => (is => 'ro', isa => InstanceOf['Marpa::R2::Scanless::G'], default => sub { $G });
has callbacks => (is => 'ro', isa => HashRef[CodeRef], default => sub { \%CALLBACKS });

sub _constant_pool_count {
  my ($self, $r) = @_;

  my $count = $self->u1($r, 'constant_pool_count');
  my $imax = $count - 1;
  my @managed = ();
  my $i = 0;
  my $pos = $self->pos;
  while (++$i <= $imax) {
    my $inner = MarpaX::Java::ClassFile::ConstantPool->new(input => $self->input, pos => $pos);
    push(@managed, $inner->ast);
    $pos = $inner->pos
  }
  $pos
}

with 'MarpaX::Java::ClassFile::Common';

1;

__DATA__
event 'constant_pool_count$' = completed constant_pool_count
ClassFile ::=
             magic
             minor_version
             major_version
             constant_pool_count
             constant_pool
             access_flags
             this_class
             super_class
             interfaces_count
             interfaces
             fields_count
             fields
             methods_count
             methods
             attributes_count
             attributes
magic               ::= u4
minor_version       ::= u2
major_version       ::= u2
constant_pool_count ::= u2
constant_pool       ::= managed
access_flags        ::= u2
this_class          ::= u2
super_class         ::= u2
interfaces_count    ::= u2
interfaces          ::= u2
fields_count        ::= u2
fields              ::= managed
methods_count       ::= u2
methods             ::= managed
attributes_count    ::= u2
attributes          ::= managed
