use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Role::Parser;

# ABSTRACT: Parsing engine role for .class file parsing

# VERSION

# AUTHORITY

use Moo::Role;
#
# Note: This package is part of the core of the engine. Therefore it
# optimized except the logging (when you trace this package, I assume
# you are not interested in micro-optimizations)
#
use Carp qw/croak/;
use Class::Load qw/load_class/;
use MarpaX::Java::ClassFile::Struct::_Types -all;
use MarpaX::Java::ClassFile::Util::MarpaTrace;
use Data::Section -setup;
use Scalar::Util qw/blessed/;
use Types::Common::Numeric -all;
use Types::Standard -all;
use Types::Encodings qw/Bytes/;
use Try::Tiny;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::Role::Parser is the parse engine role used by L<MarpaX::Java::ClassFile::ClassFile>, please refer to the later.

=cut

has inputRef      => (is => 'ro',  isa => ScalarRef[Bytes],  required => 1);
has parent        => ( is => 'ro', isa => Undef|ConsumerOf['MarpaX::Java::ClassFile::Role::Parser']);
has constant_pool => (is => 'ro',  isa => ArrayRef[CpInfo],  default => sub { [] } );
has max           => (is => 'rwp', isa => PositiveOrZeroInt, lazy => 1, builder => 1);
has pos           => (is => 'rwp', isa => PositiveOrZeroInt, default => sub { 0 });
has whoami        => (is => 'ro',  isa => Str,               lazy => 1, builder => 1);
has ast           => (is => 'ro',  isa => Object,            lazy => 1, builder => 1);
has exhaustion    => (is => 'ro',  isa => Str,               default => sub { 'fatal' });
has _r            => (is => 'rw',  isa => InstanceOf['Marpa::R2::Scanless::R'], lazy => 1, builder => 1, predicate => 1, clearer => 1);

my $MARPA_TRACE_FILE_HANDLE;
my $MARPA_TRACE_BUFFER;

sub BEGIN {
    #
    ## We do not want Marpa to pollute STDERR
    #
    ## Autovivify a new file handle
    #
    open($MARPA_TRACE_FILE_HANDLE, '>', \$MARPA_TRACE_BUFFER);
    if (! defined($MARPA_TRACE_FILE_HANDLE)) {
      croak "Cannot create temporary file handle to tie Marpa logging, $!\n";
    } else {
      if (! tie ${$MARPA_TRACE_FILE_HANDLE}, 'MarpaX::Java::ClassFile::Util::MarpaTrace') {
        croak "Cannot tie $MARPA_TRACE_FILE_HANDLE, $!\n";
        if (! close($MARPA_TRACE_FILE_HANDLE)) {
          croak "Cannot close temporary file handle, $!\n";
        }
        $MARPA_TRACE_FILE_HANDLE = undef;
      }
    }
}

sub _build_max {
  # my ($self) = @_;
  length(${$_[0]->inputRef})
}

sub _build_whoami {
  # my ($self, $class) = @_;
  my $whoami = (split(/::/, $_[1] // blessed($_[0])))[-1];

  return join('->', $_[0]->parent->whoami, $whoami) if (defined($_[0]->parent));
  $whoami
}

# -----------------------
# General events dispatch
# -----------------------
sub manageEvents {
  # my ($self) = @_;

  my @eventNames = map { $_->[0] } (@{$_[0]->_events});
  # $_[0]->tracef('Events: %s', \@eventNames);
  foreach (@eventNames) {
    $_[0]->tracef('--------- %s', $_);
    my $callback = $_[0]->callbacks->{$_};
    $_[0]->_croak("Unmanaged event $_") unless defined($callback);
    $_[0]->$callback
  }
}

sub _build__r {
  # my ($self) = @_;
  Marpa::R2::Scanless::R->new({
                               trace_file_handle => $MARPA_TRACE_FILE_HANDLE,
                               grammar           => $_[0]->grammar,
                               exhaustion        => $_[0]->exhaustion,
                               trace_terminals   => $_[0]->_logger->is_trace
                              })
}

sub _build_ast {
  # my ($self) = @_;
  #
  # For our marpa tied logger
  #
  no warnings 'once';
  local $MarpaX::Java::ClassFile::Role::Parser::SELF = $_[0];
  #
  # It is far quicker to maintain ourself booleans for trace and debug mode
  # rather than letting logger's tracef() and debugf() handle the request
  #
  local $MarpaX::Java::ClassFile::Role::Parser::IS_TRACE    = $_[0]->_logger->is_trace;
  local $MarpaX::Java::ClassFile::Role::Parser::IS_DEBUG    = $_[0]->_logger->is_debug;
  local $MarpaX::Java::ClassFile::Role::Parser::IS_INFO     = $_[0]->_logger->is_info;
  local $MarpaX::Java::ClassFile::Role::Parser::IS_WARN     = $_[0]->_logger->is_warn;
  local $MarpaX::Java::ClassFile::Role::Parser::IS_ERROR    = $_[0]->_logger->is_error;

  $_[0]->_read;
  while ($_[0]->pos < $_[0]->max) { $_[0]->_resume }
  $_[0]->_value
}

sub exhausted {
  $_[0]->_set_max($_[0]->pos)
}

sub _read {
  # my ($self) = @_;

  $_[0]->tracef('read($inputRef, %s)', $_[0]->pos);
  eval {
    $_[0]->_set_pos($_[0]->_r->read($_[0]->inputRef, $_[0]->pos))
  };
  $_[0]->_croak($@) if ($@);
  $_[0]->manageEvents
}

sub _events {
  # my ($self) = @_;

  $_[0]->tracef('events()');
  my $eventsRef = eval { $_[0]->_r->events };
  $_[0]->_croak($@) if ($@);
  $eventsRef
}

sub _value {
  # my ($self) = @_;

  $_[0]->tracef('ambiguity_metric()');
  my $ambiguity_metric = eval { $_[0]->_r->ambiguity_metric() };
  $_[0]->_croak($@) if ($@);
  $_[0]->_croak('Ambiguity metric is undefined') if (! defined($ambiguity_metric));
  $_[0]->_croak('Parse is ambiguous') if ($ambiguity_metric != 1);

  $_[0]->tracef('value($_[0])');
  local $MarpaX::Java::ClassFile::Role::Parser::VALUE_CONTEXT = 1;
  my $valueRef = eval { $_[0]->_r->value($_[0]) };
  $_[0]->_croak($@) if ($@);
  $_[0]->_croak('Value reference is undefined') if (! defined($valueRef));

  my $value = ${$valueRef};
  $_[0]->_croak('Value is undefined') if (! defined($value));
  #
  # We do not need the recognizer anymore
  #
  $_[0]->_clear_r;

  $value
}

sub _resume {
  # my ($self) = @_;

  $_[0]->tracef('resume(%s)', $_[0]->pos);
  eval { $_[0]->_set_pos($_[0]->_r->resume($_[0]->pos)) };
  $_[0]->_croak($@) if ($@);
  $_[0]->manageEvents
}

sub _literal {
  # my ($self, $symbol) = @_;

  $_[0]->tracef('last_completed_span(\'%s\')', $_[1]);
  my @span = $_[0]->_r->last_completed_span($_[1]);
  $_[0]->_croak("No symbol instance for the symbol $_[1]") if (! @span);
  $_[0]->tracef('literal(%s, %s)', $span[0], $span[1]);
  $_[0]->_r->literal(@span)
}

#
# Helper to read a MANAGED lexeme
#
sub lexeme_read_managed {
  # my ($self, $lexeme_length, $ignoreEvents) = @_;

  my $rc;
  if ($_[1]) {
    $_[0]->fatalf('Not enough bytes') if ($_[1] + $_[0]->pos >= $_[0]->max);
    my $bytes = substr(${$_[0]->inputRef}, $_[0]->pos, $_[1]);
    $_[0]->lexeme_read('MANAGED', $_[1], $bytes, $_[2])
  } else {
    $_[0]->lexeme_read('MANAGED', 0, undef, $_[2])
  }
}

sub lexeme_read {
  # my ($self, $lexeme_name, $lexeme_length, $lexeme_value, $ignoreEvents) = @_;

  #
  # If the length is zero, force the read to be at position 0.
  # We will anyway explicitely re-set position and it works
  # because we always do $self->_r->resume($self->pos) -;
  #
  my $_lexeme_length = $_[2] || 1;
  my $_lexeme_pos    = $_[2] ? $_[0]->pos : 0;
  $_[0]->tracef('lexeme_read(\'%s\', %s, %s, $value)', $_[1], $_lexeme_pos, $_lexeme_length);
  my $pos;
  eval {
    #
    # Do the lexeme_read in any case
    #
    $pos = $_[0]->_r->lexeme_read($_[1], $_lexeme_pos, $_lexeme_length, $_[3]) || croak sprintf('lexeme_read failure for symbol %s at position %s, length %s', $_[1], $_lexeme_pos, $_lexeme_length);
    #
    # And commit its return position unless length is 0
    #
    $_[0]->_set_pos($pos) if ($_[2])
  };
  $_[0]->_croak($@) if ($@);
  $_[0]->manageEvents unless ($_[4])
}

sub literalU1 {
  # my ($self, $symbol) = @_;

  my $u1 = $_[0]->u1($_[0]->_literal('u1'));
  $_[0]->tracef('Got u1=%s', $u1);
  $u1
}

sub literalU2 {
  # my ($self, $_[1]) = @_;

  my $u2 = $_[0]->u2($_[0]->_literal('u2'));
  $_[0]->tracef('Got u2=%s', $u2);
  $u2
}

sub literalU4 {
  # my ($self, $symbol) = @_;

  my $u4 = $_[0]->u4($_[0]->_literal('u4'));
  $_[0]->tracef('Got u4=%s', $u4);
  $u4
}

sub literalManaged {
  # my ($self, $symbol) = @_;

  $_[0]->_literal('managed')
}

sub activate {
  # my ($self, $eventName, $status) = @_;

  $_[0]->tracef('activate(\'%s\', %s)', $_[1], $_[2]);
  $_[0]->_r->activate($_[1], $_[2])
}

#
# An inner grammar is an opaque thing, so associated
# lexeme must be MANAGED.
#
sub inner {
  # my ($self, $innerGrammarClass, %args) = @_;

  my $innerClass = "MarpaX::Java::ClassFile::BNF::$_[1]";
  load_class($innerClass);
  my $inner = $innerClass->new(parent => $_[0],
                               constant_pool => $_[0]->constant_pool,
                               inputRef => $_[0]->inputRef,
                               pos => $_[0]->pos,
                               @_[2..$#_]);
  my $innerGrammarValue = $inner->ast;
  $_[0]->lexeme_read('MANAGED', $inner->pos - $_[0]->pos, $innerGrammarValue);
  $innerGrammarValue
}

#
# Logging/croak stuff : voluntarily not optimized
#
sub _dolog {
  my ($self, $method, $format, @arguments) = @_;

  #
  # If we are in an action, we do nothing else
  # but propage the message to the log handler
  # as-is. Current and max positions are meaningul
  # only in the lexing phase, that may not use
  # another level but TRACE btw -;
  #
  if ($MarpaX::Java::ClassFile::Role::Parser::VALUE_CONTEXT) {
    $self->_logger->$method($format, @arguments)
  } else {
    my $inputLength = length(${$self->inputRef});
    my $nbcharacters = length("$inputLength");
    my ($offset, $max) = ($self->pos, $self->max);

    $self->_logger->$method("[pos %*s->%*s] %s: $format", $nbcharacters, $offset, $nbcharacters, $self->max, $self->whoami, @arguments)
  }
}

sub debugf {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Role::Parser::IS_DEBUG;
  $self->_dolog('debugf', $format, @arguments);
}

sub infof {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Role::Parser::IS_INFO;
  $self->_dolog('infof', $format, @arguments);
}

sub errorf {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Role::Parser::IS_ERROR;
  $self->_dolog('errorf', $format, @arguments);
}

sub warnf {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Role::Parser::IS_WARN;
  $self->_dolog('warnf', $format, @arguments);
}

sub tracef {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Role::Parser::IS_TRACE;
  $self->_dolog('tracef', $format, @arguments);
}

sub fatalf {
  my ($self, $format, @arguments) = @_;

  croak sprintf($format, @arguments)
}

sub _croak {
  my ($self, $msg) = @_;

  $msg //= '';
  #
  # Should never happen that $self->_r is not set at this stage but who knows
  #
  $msg .= "\nContext:\n" . $self->_r->show_progress if $self->_has_r;
  croak($msg)
}

with qw/MooX::Role::Logger MarpaX::Java::ClassFile::Role::Parser::Actions/;

requires 'callbacks';
requires 'grammar';

1;
