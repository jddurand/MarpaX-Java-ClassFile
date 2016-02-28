use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::FieldsArray;

# ABSTRACT: Java .class's field_info parsing

# VERSION

# AUTHORITY

use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::AttributesArray;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use Types::Common::Numeric -all;
use Types::Standard -all;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('attributesCount$' => \&_attributesCountCallback,
                  'fieldInfo$'       => \&_fieldInfoCallback
                 );

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
sub _attributesCountCallback {
  my ($self, $r) = @_;
  $self->executeInnerGrammar($r, 'MarpaX::Java::ClassFile::AttributesArray', 'MANAGED', size => $self->literalU2($r))
}

sub _fieldInfoCallback {
  my ($self, $r) = @_;
  $self->_nbDone($self->_nbDone + 1);
  $self->debugf('Completed');
  $self->max($self->pos) if ($self->_nbDone >= $self->size);
}

# --------------------
# Our grammar actions
# --------------------
sub _fieldInfo {
  my $i = 0;
  bless({
         access_flags     => $_[++$i],
         name_index       => $_[++$i],
         descriptor_index => $_[++$i],
         attributes_count => $_[++$i],
         attributes       => $_[++$i]
        }, 'field_info')
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
event 'fieldInfo$'       = completed fieldInfo
event 'attributesCount$' = completed attributesCount

fieldArray ::= fieldInfo*  action => [values]
fieldInfo ::=
    accessFlags
    nameIndex
    descriptorIndex
    attributesCount
    attributes

accessFlags     ::= u2
nameIndex       ::= u2
descriptorIndex ::= u2
attributesCount ::= u2
attributes      ::= managed
