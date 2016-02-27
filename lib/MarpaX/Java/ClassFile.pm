use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;
use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::ConstantPoolArray;
use Scalar::Util qw/blessed/;
use Types::Standard -all;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my %_CALLBACKS = ('constantPoolCount$' => \&_constantPoolCount);

has grammar   => (is => 'ro', isa => InstanceOf['Marpa::R2::Scanless::G'], lazy => 1, builder => 1);
has callbacks => (is => 'ro', isa => HashRef[CodeRef], default => sub { \%_CALLBACKS });

sub BUILD {
  my ($self) = @_;
  $self->debugf('Starting');
}

sub _build_grammar {
  my ($self) = @_;

  Marpa::R2::Scanless::G->new({bless_package => $self->whoami, source => \__PACKAGE__->bnf($_data)})
}

sub _constantPoolCount {
  my ($self, $r) = @_;

  my $constantPoolCount = $self->literalU2($r, 'constantPoolCount');
  $self->debugf('Asking for constant pool');
  my $constantPoolArray = MarpaX::Java::ClassFile::ConstantPoolArray->new
    (
     input => $self->input,
     pos   => $self->pos,
     level => $self->level + 1,
     size  => $constantPoolCount - 1 # Hey, spec says size is $count -1
    );
  my $constantPoolArrayAst  = $constantPoolArray->ast;                # Inner value
  my $constantPoolArraySize = $constantPoolArray->pos - $self->pos;   # Inner size
  my $next_pos              = $self->pos + $constantPoolArraySize;    # Next position
  #
  # Setting optional last argument $next_pos handles the case of an empty array
  #
  $self->lexeme_read($r, 'MANAGED', $self->pos, $constantPoolArraySize, $constantPoolArrayAst, $next_pos);
  $self->debugf('Constant pool over');
}

with qw/MarpaX::Java::ClassFile::Common/;

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'constantPoolCount$' = completed constantPoolCount
ClassFile ::=
             magic
             minorVersion
             majorVersion
             constantPoolCount
             constantPoolArray
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
magic              ::= U4
minorVersion       ::= U2
majorVersion       ::= U2
constantPoolCount  ::= U2
constantPoolArray  ::= MANAGED
accessFlags        ::= U2
thisClass          ::= U2
superClass         ::= U2
interfacesCount    ::= U2
interfaces         ::= U2
fieldsCount        ::= U2
#fields              ::= managed
#methods_count       ::= u2
#methods             ::= managed
#attributes_count    ::= u2
#attributes          ::= managed
