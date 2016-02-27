use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;
use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use MarpaX::Java::ClassFile::ConstantPoolArray;
use Scalar::Util qw/blessed/;
use Types::Standard -all;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('constantPoolCount$' => \&_constantPoolCountEvent);

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ------------
# Our thingies
# ------------
sub BUILD {
  my ($self) = @_;
  $self->debugf('Starting');
}

# ---------------
# Event callbacks
# ---------------
sub _constantPoolCountEvent {
  my ($self, $r) = @_;

  my $constantPoolCount = $self->literalU2($r, 'constantPoolCount');
  $self->executeInnerGrammar($r,
                             'MarpaX::Java::ClassFile::ConstantPoolArray',
                             #
                             # Hey, spec says size of constant pool is $count -1
                             #
                             $constantPoolCount - 1)
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
#             fieldsArray
#             methods_count
#             methods
#             attributes_count
#             attributes
magic              ::= U4          action => u4
minorVersion       ::= U2          action => u2
majorVersion       ::= U2          action => u2
constantPoolCount  ::= U2          action => u2
constantPoolArray  ::= MANAGED     action => ::first
accessFlags        ::= U2          action => u2
thisClass          ::= U2          action => u2
superClass         ::= U2          action => u2
interfacesCount    ::= U2          action => u2
interfaces         ::= U2          action => u2
fieldsCount        ::= U2          action => u2
#fieldsArray        ::= MANAGED     action => ::first
#methods_count       ::= u2
#methods             ::= managed
#attributes_count    ::= u2
#attributes          ::= managed
