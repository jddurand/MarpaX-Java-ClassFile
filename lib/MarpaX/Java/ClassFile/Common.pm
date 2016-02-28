use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Common;

# ABSTRACT: Parsing engine role for .class file parsing

# VERSION

# AUTHORITY

use Moo::Role;

use Carp qw/croak/;
use MarpaX::Java::ClassFile::MarpaTrace;
use Data::Section -setup;
use Scalar::Util qw/blessed/;
use Types::Common::Numeric -all;
use Types::Standard -all;
use Types::Encodings qw/Bytes/;
use Try::Tiny;

=head1 DESCRIPTION

MarpaX::Java::ClassFile::Common is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

has input      => (is => 'ro',  isa => Bytes,                 required => 1);
has exhaustion => (is => 'ro',  isa => Enum[qw/event fatal/], default => sub { 'fatal' });
has max        => (is => 'rw',  isa => PositiveOrZeroInt,     lazy => 1, builder => 1);
has ast        => (is => 'rw',  isa => Any,                   lazy => 1, builder => 1);
has pos        => (is => 'rwp', isa => PositiveOrZeroInt,     default => sub { 0 });
has whoami     => (is => 'rwp', isa => Str,                   lazy => 1, builder => 1);
has level      => (is => 'rwp', isa => PositiveOrZeroInt,     default => sub { 0 });

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
      if (! tie ${$MARPA_TRACE_FILE_HANDLE}, 'MarpaX::Java::ClassFile::MarpaTrace') {
        croak "Cannot tie $MARPA_TRACE_FILE_HANDLE, $!\n";
        if (! close($MARPA_TRACE_FILE_HANDLE)) {
          croak "Cannot close temporary file handle, $!\n";
        }
        $MARPA_TRACE_FILE_HANDLE = undef;
      }
    }
}

sub _build_max {
  my ($self) = @_;

  length($self->input)
}

sub _whoami {
  my ($self, $class) = @_;

  (split(/::/, $class // blessed($self)))[-1]
}

sub _build_whoami {
  my ($self) = @_;

  $self->_whoami
}

# -----------------------
# General events dispatch
# -----------------------
sub _manageEvents {
  my ($self, $r) = @_;

  my @eventNames = map { $_->[0] } (@{$self->_events($r)});
  $self->tracef('Events: %s', \@eventNames);
  foreach (@eventNames) {
    $self->tracef('--------- %s', $_);
    my $callback = $self->callbacks->{$_};
    $self->_croak($r, "Unmanaged event $_") unless defined($callback);
    $self->$callback($r)
  }
}

sub _build_ast {
  my ($self) = @_;
  #
  # For our marpa tied logger
  #
  local $MarpaX::Java::ClassFile::Common::SELF = $self;
  local $MarpaX::Java::ClassFile::Common::R    = undef;
  #
  # It is far quicker to maintain ourself booleans for trace and debug mode
  # rather than letting logger's tracef() and debugf() handle the request
  #
  local $MarpaX::Java::ClassFile::Common::IS_TRACE    = $self->_logger->is_trace;
  local $MarpaX::Java::ClassFile::Common::IS_DEBUG    = $self->_logger->is_debug;
  local $MarpaX::Java::ClassFile::Common::IS_INFO     = $self->_logger->is_info;
  local $MarpaX::Java::ClassFile::Common::IS_WARN     = $self->_logger->is_warn;
  local $MarpaX::Java::ClassFile::Common::IS_ERROR    = $self->_logger->is_error;

  my $r = Marpa::R2::Scanless::R->new({trace_file_handle => $MARPA_TRACE_FILE_HANDLE,
                                       grammar => $self->grammar,
                                       exhaustion => $self->exhaustion,
                                       trace_terminals => $self->_logger->is_trace
                                      });
  $MarpaX::Java::ClassFile::Common::R = $r;

  $self->_read($r);
  while ($self->pos < $self->max) {
    $self->_resume($r)
  }

  $self->_value($r)
}

sub _dolog {
  my ($self, $method, $format, @arguments) = @_;

  my $inputLength = length($self->input);
  my $nbcharacters = length("$inputLength");
  $self->_logger->$method("%s[%*s/%*s] %s: $format", '.' x $self->level, $nbcharacters, $self->pos, $nbcharacters, $self->max, $self->whoami, @arguments)
}

sub debugf {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Common::IS_DEBUG;
  $self->_dolog('debugf', $format, @arguments);
}

sub infof {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Common::IS_INFO;
  $self->_dolog('infof', $format, @arguments);
}

sub errorf {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Common::IS_ERROR;
  $self->_dolog('errorf', $format, @arguments);
}

sub warnf {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Common::IS_WARN;
  $self->_dolog('warnf', $format, @arguments);
}

sub tracef {
  my ($self, $format, @arguments) = @_;

  return unless $MarpaX::Java::ClassFile::Common::IS_TRACE;
  $self->_dolog('tracef', $format, @arguments);
}

sub _croak {
  my ($self, $r, $msg) = @_;

  croak ($msg // '') . "\nContext:\n" . $r->show_progress
}

sub _read {
  my ($self, $r) = @_;

  $self->tracef('$r->read($inputRef, pos=%s)', $self->pos);
  try {
    $self->_set_pos($r->read(\$self->input, $self->pos))
  } catch {
    $self->_croak($r, $_)
  };
  $self->_manageEvents($r)
}

sub _events {
  my ($self, $r) = @_;

  $self->tracef('$r->events()');
  my $eventsRef;
  try {
    $eventsRef = $r->events
  } catch {
    $self->_croak($r, $_)
  };
  $eventsRef
}

sub _value {
  my ($self, $r) = @_;

  my $ambiguity_metric;
  $self->tracef('$r->ambiguity_metric()');
  try {
    $ambiguity_metric = $r->ambiguity_metric()
  } catch {
    $self->_croak($r, $_)
  };
  if (! defined($ambiguity_metric)) {
    $self->_croak($r, 'Ambiguity metric is undefined')
  } elsif ($ambiguity_metric != 1) {
    $self->_croak($r, 'Parse is ambiguous')
  }

  $self->tracef('$r->value($self)');
  my $valueRef;
  try {
    $valueRef = $r->value($self)
  } catch {
    $self->_croak($r, $_)
  };
  $self->_croak($r, 'Value reference is undefined') if (! defined($valueRef));
  my $value = ${$valueRef};
  #
  # It is definitely an error to have an undefined value
  #
  $self->_croak($r, 'Value is undefined') if (! defined($value));
  $value
}

sub _resume {
  my ($self, $r) = @_;

  $self->tracef('$r->resume(%d)', $self->pos);
  try {
    $self->_set_pos($r->resume($self->pos))
  } catch {
    $self->_croak($r, $_)
  };
  $self->_manageEvents($r)
}

sub _literal {
  my ($self, $r, $symbol) = @_;

  $self->tracef('$r->last_completed_span(\'%s\')', $symbol);
  my @span = $r->last_completed_span($symbol);
  $self->_croak($r, "No symbol instance for the symbol $symbol") if (! @span);
  $self->tracef('$r->literal(%s, %s)', $span[0], $span[1]);
  $r->literal(@span)
}

sub lexeme_read {
  my ($self, $r, $lexeme_name, $lexeme_length, $lexeme_value) = @_;

  #
  # If the length is zero, force the read to be at position 0.
  # We will anyway explicitely re-set position and it works
  # because we always do $r->resume($self->pos) -;
  #
  my $_lexeme_length = $lexeme_length || 1;
  my $_lexeme_pos    = $lexeme_length ? $self->pos : 0;
  $self->tracef('$r->lexeme_read(name=\'%s\', pos=%s, length=%s, $value)', $lexeme_name, $_lexeme_pos, $_lexeme_length);
  try {
    #
    # Do the lexeme_read in any case
    #
    my $pos = $r->lexeme_read($lexeme_name, $_lexeme_pos, $_lexeme_length, $lexeme_value) || croak sprintf('lexeme_read failure for symbol %s at position %s, length %s', $lexeme_name, $_lexeme_pos, $_lexeme_length);
    #
    # And commit its return position unless length is 0
    #
    $self->_set_pos($pos) if ($lexeme_length)
  } catch {
    $self->_croak($r, $_)
  };
  $self->_manageEvents($r)
}

sub literalU1 {
  my ($self, $r, $symbol) = @_;

  my $u1 = $self->u1($self->_literal($r, $symbol //= 'u1'));
  $self->tracef('Got %s=%s', $symbol, $u1);
  $u1
}

sub literalU2 {
  my ($self, $r, $symbol) = @_;

  my $u2 = $self->u2($self->_literal($r, $symbol //= 'u2'));
  $self->tracef('Got %s=%s', $symbol, $u2);
  $u2
}

sub literalU4 {
  my ($self, $r, $symbol) = @_;

  my $u4 = $self->u4($self->_literal($r, $symbol //= 'u4'));
  $self->tracef('Got %s=%s', $symbol, $u4);
  $u4
}

sub executeInnerGrammar {
  my ($self, $r, $innerGrammarClass, $lexeme_name, %args) = @_;

  my $whoisit = $self->_whoami($innerGrammarClass);
  $self->debugf('Asking for %s', $whoisit);
  my $inner = $innerGrammarClass->new(input => $self->input, pos => $self->pos, level => $self->level + 1, %args);
  my $value = $inner->ast;    # It is very important to call ast BEFORE calling pos
  my $length = $inner->pos - $self->pos;
  $self->lexeme_read($r, $lexeme_name, $length, $value);
  $self->debugf('%s over', $whoisit)
}

with qw/MooX::Role::Logger MarpaX::Java::ClassFile::Common::Actions/;

requires 'callbacks';
requires 'grammar';

1;
