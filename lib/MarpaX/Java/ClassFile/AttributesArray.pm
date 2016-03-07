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
use MarpaX::Java::ClassFile::Attribute::ConstantValue;
use MarpaX::Java::ClassFile::Attribute::Code;
use MarpaX::Java::ClassFile::Attribute::StackMapTable;
use MarpaX::Java::ClassFile::Attribute::Unmanaged;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::AttributesArray is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('attributeInfo$' => \&_attributeInfoCallback,
                  '^U2'            => \&_U2Callback);

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ---------------
# Event callbacks
# ---------------
sub _attributeInfoCallback {
  my ($self) = @_;

  $self->nbDone($self->nbDone + 1);
  $self->max($self->pos) if ($self->nbDone >= $self->size); # Set the max position so that parsing end
}

sub _U2Callback {
  my ($self) = @_;
  #
  # No need to check if we can read this U2: this is a predicted lexeme so it
  # is guaranteed we can do so
  #
  my $U2                 = substr(${$self->inputRef}, $self->pos, 2);
  my $attributeNameIndex = $self->u2($U2);
  my $attributeName      = $self->classFile->constantPoolArray->[$attributeNameIndex]->computed_value;

  if ($attributeName eq 'ConstantValue') {
    $self->executeInnerGrammar('MarpaX::Java::ClassFile::Attribute::ConstantValue',
                               'first',
                               classFile => $self->classFile,
                               size => 1);
  }
  elsif ($attributeName eq 'Code') {
    $self->executeInnerGrammar('MarpaX::Java::ClassFile::Attribute::Code',
                               'first',
                               classFile => $self->classFile,
                               size => 1);
  }
  elsif ($attributeName eq 'StackMapTable') {
    $self->executeInnerGrammar('MarpaX::Java::ClassFile::Attribute::StackMapTable',
                               'first',
                               classFile => $self->classFile,
                               size => 1);
  }
  else {
    $self->executeInnerGrammar('MarpaX::Java::ClassFile::Attribute::Unmanaged',
                               'first',
                               classFile => $self->classFile,
                               size => 1);
  }
}

with qw/MarpaX::Java::ClassFile::Common::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
  :default ::= action => ::first
event 'attributeInfo$' = completed attributeInfo
:lexeme ~ U2 pause => before event => '^U2'

attributesArray    ::= attributeInfo*    action => [values]
attributeInfo      ::= U2                # U2 is only used for dispatch
                     | managed
