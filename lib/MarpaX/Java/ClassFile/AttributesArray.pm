use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::AttributesArray;

# ABSTRACT: Java .class's attribute_info parsing

# VERSION

# AUTHORITY

use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::AttributesArray is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('attributeLength$' => \&_attributeLengthEvent,
                  'attributeInfo$'   => \&_attributeInfoEvent
                 );

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ---------------
# Event callbacks
# ---------------
sub _attributeLengthEvent {
  my ($self) = @_;

  my $attributeLength = $self->literalU4;                                   # Can be 0
  my $bytes           = substr($self->input, $self->pos, $attributeLength); # Ok when length is 0
  my $value           = [ split('', $bytes) ];                              # Value is an array of u1
  $self->lexeme_read('MANAGED', $attributeLength, $value);                  # This lexeme_read() handles case of length 0
}

sub _attributeInfoEvent {
  my ($self) = @_;
  $self->debugf('Completed');
  $self->_nbDone($self->_nbDone + 1);
  $self->max($self->pos) if ($self->_nbDone >= $self->size);
}

# --------------------
# Our grammar actions
# --------------------
sub _attributeInfo {
  my $i = 0;
  bless({
         access_flags     => $_[++$i],
         name_index       => $_[++$i],
         descriptor_index => $_[++$i],
         attributes_count => $_[++$i],
         attributes       => $_[++$i]
        }, 'attribute_info')
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'attributeInfo$'   = completed attributeInfo
event 'attributeLength$' = completed attributeLength

attributeArray ::= attributeInfo*  action => [values]
attributeInfo ::=
 attributeNameIndex
 attributeLength
 infoBytes

attributeNameIndex ::= u2
attributeLength    ::= u4
infoBytes          ::= managed
