use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;
use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::ConstantPool;
use Types::Standard -all;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my %_CALLBACKS = ('constantPoolCount$' => \&_constantPoolCount);

has grammar   => (is => 'ro', isa => InstanceOf['Marpa::R2::Scanless::G'], lazy => 1, builder => 1);
has callbacks => (is => 'ro', isa => HashRef[CodeRef], default => sub { \%_CALLBACKS });

sub _build_grammar {
  my ($self) = @_;

  Marpa::R2::Scanless::G->new({bless_package => 'ClassFile', source => \__PACKAGE__->bnf($_data)})
}

sub _constantPoolCount {
  my ($self, $r) = @_;

  my $count = $self->literalU2($r, 'constantPoolCount');
  my $imax = $count - 1;
  my @managed = ();
  my $i = 0;
  my $lastPos = $self->pos;
  while (++$i <= $imax) {
    my $inner = MarpaX::Java::ClassFile::ConstantPool->new(input => $self->input, pos => $lastPos, level => $self->level + 1);
    push(@managed, $inner->ast);
    $lastPos = $inner->pos
  }
}

with qw/MarpaX::Java::ClassFile::BNF
        MarpaX::Java::ClassFile::Common/;

1;

__DATA__
__[ bnf ]__
event 'constantPoolCount$' = completed constantPoolCount
ClassFile ::=
             magic
             minorVersion
             majorVersion
             constantPoolCount
             constantPool
             accessFlags
             thisClass
             superClass
             interfacesCount
             interfaces
             fieldsCount
#             fields
#             methods_count
#             methods
#             attributes_count
#             attributes
magic              ::= u4
minorVersion       ::= u2
majorVersion       ::= u2
constantPoolCount  ::= u2
constantPool       ::= managed
accessFlags        ::= u2
thisClass          ::= u2
superClass         ::= u2
interfacesCount    ::= u2
interfaces         ::= u2
fieldsCount        ::= u2
#fields              ::= managed
#methods_count       ::= u2
#methods             ::= managed
#attributes_count    ::= u2
#attributes          ::= managed
