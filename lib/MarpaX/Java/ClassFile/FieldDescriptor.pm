use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::FieldDescriptor;

# ABSTRACT: Java .class's field_info's descriptor parsing

# VERSION

# AUTHORITY

use Moo;

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::FieldDescriptor is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

my $_data      = ${__PACKAGE__->section_data('bnf')};
my $_grammar   = Marpa::R2::Scanless::G->new({source => \__PACKAGE__->bnf($_data)});
my %_CALLBACKS = ('utf8Length$'      => \&_utf8LengthCallback,
                  'FieldDescriptor$' => \&_FieldDescriptorCallback);

# ----------------------------------------------------------------
# What role MarpaX::Java::ClassFile::Common::InnerGrammar requires
# ----------------------------------------------------------------
sub grammar   { $_grammar }
sub callbacks { \%_CALLBACKS }

# ---------------
# Event callbacks
# ---------------
sub _utf8LengthCallback {
  my ($self) = @_;

  my $utf8Length = $self->literalU2;
  my $utf8String = $utf8Length ? substr($self->input, $self->pos, $utf8Length) : undef;
  $self->tracef('Modified UTF-8: %s', $utf8String);
  $self->lexeme_read('MANAGED', $utf8Length, $utf8String);  # Note: this lexeme_read() handles case of length 0
}

sub _FieldDescriptorCallback {
  my ($self) = @_;
  $self->debugf('Completed');
  $self->max($self->pos)
}

# --------------------
# Our grammar actions
# --------------------
sub _FieldDescriptor {
  bless({FieldType => $_[1]}, 'FieldDescriptor')
}

sub _BaseType {
  bless(\$_[1], 'BaseType')
}

sub _ObjectType {
  bless(\$_[1], 'ObjectType')
}

sub _ArrayType {
  bless(\$_[1], 'ArrayType')
}

sub _ComponentType {
  bless(\$_[1], 'ComponentType')
}

with qw/MarpaX::Java::ClassFile::Common/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'FieldDescriptor$' = completed FieldDescriptor
event 'utf8Length$'      = completed utf8Length

FieldDescriptor  ::= FieldType                       action => _FieldDescriptor
FieldType        ::= BaseType
                   | ObjectType
                   | ArrayType
BaseType         ::= [BCDFIJSZ]                      action => _BaseType
ObjectType       ::= ('L') ClassName (';')           action => _ObjectType
ArrayType        ::= ('[') ComponentType             action => _ArrayType
ComponentType    ::= FieldType                       action => _ComponentType

ClassName        ::= constantUtf8Info
constantUtf8Info ::= ([\x{01}] utf8Length) utf8Bytes action =>  _constantUtf8Info
utf8Length       ::= u2
utf8Bytes        ::= MANAGED                         action => utf8             # MANAGED and not managed
