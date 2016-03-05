use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::MethodsArray;

# ABSTRACT: Java .class's method_info parsing

# VERSION

# AUTHORITY

use Moo;
# Note: MethodsArray is simply a clone of FieldsArray -;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::AttributesArray;
use MarpaX::Java::ClassFile::Method;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::MethodsArray is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('attributesCount$' => \&_attributesCountCallback,
                  'methodInfo$'      => \&_methodInfoCallback
                 );

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ---------------
# Event callbacks
# ---------------
sub _attributesCountCallback {
  my ($self) = @_;
  $self->executeInnerGrammar('MarpaX::Java::ClassFile::AttributesArray', 'array', size => $self->literalU2)
}

sub _methodInfoCallback {
  my ($self) = @_;
  $self->nbDone($self->nbDone + 1);
  $self->debugf('Completed');
  $self->max($self->pos) if ($self->nbDone >= $self->size);
}

# --------------------
# Our grammar actions
# --------------------
sub _methodInfo {
  my ($self, $accessFlags, $nameIndex, $descriptorIndex, $attributesCount, $attributes) = @_;

  MarpaX::Java::ClassFile::Method->new(access_flags     => $accessFlags,
                                       name_index       => $nameIndex,
                                       descriptor_index => $descriptorIndex,
                                       attributes_count => $attributesCount,
                                       attributes       => $attributes
                                     )
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'methodInfo$'       = completed methodInfo
event 'attributesCount$'  = completed attributesCount

methodArray ::= methodInfo*  action => [values]
methodInfo ::=
    accessFlags
    nameIndex
    descriptorIndex
    attributesCount
    attributes               action => _methodInfo

accessFlags     ::= u2
nameIndex       ::= u2
descriptorIndex ::= u2
attributesCount ::= u2
attributes      ::= managed
