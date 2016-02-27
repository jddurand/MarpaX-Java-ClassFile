use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::ConstantPoolArray;
use Moo;

use Data::Section -setup;
use Marpa::R2;
use Types::Common::Numeric -all;
use Types::Standard -all;

my $_data      = ${__PACKAGE__->section_data('bnf')};
my %_CALLBACKS = ('utf8Length$' => sub {
                    my ($self, $r) = @_;

                    my $utf8Length = $self->literalU2($r, 'utf8Length');
                    $self->lexeme_read($r,
                                       'MANAGED',
                                       $self->pos,
                                       $utf8Length,
                                       substr($self->input, $self->pos, $utf8Length)
                                      ) if ($utf8Length > 0);
                  },
                  'constantLongInfo$' => sub {
                    my ($self, $r) = @_;

                    $self->_skipNextEntry(1);
                  },
                  'constantDoubleInfo$' => sub {
                    my ($self, $r) = @_;

                    $self->_skipNextEntry(1);
                  },
                  'cpInfo$' => sub {
                    my ($self, $r) = @_;
                    $self->_nbDone($self->_nbDone + 1);
                    $self->debugf('Completed');
                    if ($self->_skipNextEntry) {
                      $self->debugf('Skipping next entry');
                      $self->_nbDone($self->_nbDone + 1);
                      $self->_skipNextEntry(0)
                    }
                    $self->max($self->pos) if ($self->_nbDone >= $self->size); # Set the max position so that parsing end
                  }
                 );

has size            => (is => 'ro', isa => PositiveOrZeroInt,                    required => 1);
has grammar         => (is => 'ro', isa => InstanceOf['Marpa::R2::Scanless::G'], lazy => 1, builder => 1);
has callbacks       => (is => 'ro', isa => HashRef[CodeRef],                     default => sub { \%_CALLBACKS });
has _lastTag        => (is => 'rw', isa => PositiveOrZeroInt,                    default => sub { 0 });  # Tag with value 0 does not exist -;
has _nbDone         => (is => 'rw', isa => PositiveOrZeroInt,                    default => sub { 0 });
has _skipNextEntry  => (is => 'rw', isa => Bool,                                 default => sub { 0 });

sub BUILD {
  my ($self) = @_;
  $self->debugf('Starting');
  $self->ast([]) if (! $self->size)
}

sub _build_grammar {
  my ($self) = @_;

  Marpa::R2::Scanless::G->new({bless_package => $self->whoami, source => \__PACKAGE__->bnf($_data)})
}

my %_ARG2HASH =
  (
   CONSTANT_Class_info              => [qw/name_index/],
   CONSTANT_Fieldref_info           => [qw/class_index name_and_type_index/],
   CONSTANT_Methodref_info          => [qw/class_index name_and_type_index/],
   CONSTANT_InterfaceMethodref_info => [qw/class_index name_and_type_index/],
   CONSTANT_String_info             => [qw/string_index/],
   CONSTANT_Integer_info            => [qw/computed_value/],
   CONSTANT_Float_info              => [qw/computed_value/],
   CONSTANT_Long_info               => [qw/computed_value/],
   CONSTANT_Double_info             => [qw/computed_value/],
   CONSTANT_NameAndType_info        => [qw/name_index descriptor_index/],
   CONSTANT_Utf8_info               => [qw/length computed_value/],
   CONSTANT_MethodHandle_info       => [qw/reference_kind reference_index/],
   CONSTANT_MethodType_info         => [qw/descriptor_index/],
   CONSTANT_InvokeDynamic_info      => [qw/bootstrap_method_attr_index name_and_type_index/],
  );

sub _arg2hash {
  my ($self, $struct, @args) = @_;

  my $descArrayRef = $_ARG2HASH{$struct};
  my %hash = ();
  foreach (0..$#args) {
    $hash{$descArrayRef->[$_]} = $args[$_]
  }
  bless \%hash, $struct
}

sub _constantClassInfo              { $_[0]->_arg2hash('CONSTANT_Class_info',              @_[1..$#_]) }
sub _constantFieldrefInfo           { $_[0]->_arg2hash('CONSTANT_Fieldref_info',           @_[1..$#_]) }
sub _constantMethodrefInfo          { $_[0]->_arg2hash('CONSTANT_Methodref_info',          @_[1..$#_]) }
sub _constantInterfaceMethodrefInfo { $_[0]->_arg2hash('CONSTANT_InterfaceMethodref_info', @_[1..$#_]) }
sub _constantStringInfo             { $_[0]->_arg2hash('CONSTANT_String_info',             @_[1..$#_]) }
sub _constantIntegerInfo            { $_[0]->_arg2hash('CONSTANT_Integer_info',            @_[1..$#_]) }
sub _constantFloatInfo              { $_[0]->_arg2hash('CONSTANT_Float_info',              @_[1..$#_]) }
sub _constantLongInfo               { $_[0]->_arg2hash('CONSTANT_Long_info',               @_[1..$#_]) }
sub _constantDoubleInfo             { $_[0]->_arg2hash('CONSTANT_Double_info',             @_[1..$#_]) }
sub _constantNameAndTypeInfo        { $_[0]->_arg2hash('CONSTANT_NameAndType_info',        @_[1..$#_]) }
sub _constantUtf8Info               { $_[0]->_arg2hash('CONSTANT_Utf8_info',               @_[1..$#_]) }
sub _constantUtf8Info_empty         { $_[0]->_arg2hash('CONSTANT_Utf8_info',               0, undef  ) }
sub _constantMethodHandleInfo       { $_[0]->_arg2hash('CONSTANT_MethodHandle_info',       @_[1..$#_]) }
sub _constantMethodType             { $_[0]->_arg2hash('CONSTANT_MethodType_info',         @_[1..$#_]) }
sub _constantInvokeDynamic          { $_[0]->_arg2hash('CONSTANT_InvokeDynamic_info',      @_[1..$#_]) }

with qw/MarpaX::Java::ClassFile::Common/;

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
event 'cpInfo$' = completed cpInfo
event 'utf8Length$'         = completed utf8Length
event 'constantLongInfo$'   = completed constantLongInfo
event 'constantDoubleInfo$' = completed constantDoubleInfo

cpInfoArray ::= cpInfo*                                            action => [values]
cpInfo ::=
    constantClassInfo                                              action => ::first
  | constantFieldrefInfo                                           action => ::first
  | constantMethodrefInfo                                          action => ::first
  | constantInterfaceMethodrefInfo                                 action => ::first
  | constantStringInfo                                             action => ::first
  | constantIntegerInfo                                            action => ::first
  | constantFloatInfo                                              action => ::first
  | constantLongInfo                                               action => ::first
  | constantDoubleInfo                                             action => ::first
  | constantNameAndTypeInfo                                        action => ::first
  | constantUtf8Info                                               action => ::first
  | constantMethodHandleInfo                                       action => ::first
  | constantMethodTypeInfo                                         action => ::first
  | constantInvokeDynamicInfo                                      action => ::first
#
# Note: a single byte is endianness independant, this is why it is ok
# to write it in the \x{} form here
#
constantClassInfo              ::= ([\x{07}]) u2                   action => _constantClassInfo
constantFieldrefInfo           ::= ([\x{09}]) u2 u2                action => _constantFieldrefInfo
constantMethodrefInfo          ::= ([\x{0a}]) u2 u2                action => _constantMethodrefInfo
constantInterfaceMethodrefInfo ::= ([\x{0b}]) u2 u2                action => _constantInterfaceMethodrefInfo
constantStringInfo             ::= ([\x{08}]) u2                   action => _constantStringInfo
constantIntegerInfo            ::= ([\x{03}]) integerBytes         action => _constantIntegerInfo
constantFloatInfo              ::= ([\x{04}]) floatBytes           action => _constantFloatInfo
constantLongInfo               ::= ([\x{05}]) longBytes            action => _constantLongInfo
constantDoubleInfo             ::= ([\x{06}]) doubleBytes          action => _constantDoubleInfo
constantNameAndTypeInfo        ::= ([\x{0c}]) u2 u2                action => _constantNameAndTypeInfo
constantUtf8Info               ::= (EMPTY_UTF8)                    action => _constantUtf8Info_empty
                                 | ([\x{01}]) utf8Length utf8Bytes action => _constantUtf8Info
constantMethodHandleInfo       ::= ([\x{0f}]) u1 u2                action => _constantMethodHandleInfo
constantMethodTypeInfo         ::= ([\x{10}]) u2                   action => _constantMethodType
constantInvokeDynamicInfo      ::= ([\x{12}]) u2 u2                action => _constantInvokeDynamic

integerBytes               ::= U4      action => integer
floatBytes                 ::= U4      action => float
longBytes                  ::= U4 U4   action => long
doubleBytes                ::= U4 U4   action => double
utf8Length                 ::= U2      action => u2
utf8Bytes                  ::= MANAGED action => utf8
#
# Subtility here: this lexeme will be three bytes long, so will have precedence over
# seeing two lexemes "\x{01}", then "\x{00}\x{00}"
#
EMPTY_UTF8                   ~ [\x{01}] [\x{00}] [\x{00}]
