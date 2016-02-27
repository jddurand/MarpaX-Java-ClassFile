use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Common;
use Moo::Role;

use Carp qw/croak/;
use MarpaX::Java::ClassFile::MarpaTrace;
use Data::Section -setup;
use Scalar::Util qw/blessed/;
use Types::Common::Numeric -all;
use Types::Standard -all;
use Types::Encodings qw/Bytes/;
use Try::Tiny;

has input  => (is => 'ro',  isa => Bytes, required => 1);
has max    => (is => 'rw', isa => PositiveOrZeroInt, lazy => 1, builder => 1);
has ast    => (is => 'rwp', isa => Any, lazy => 1, builder => 1);
has pos    => (is => 'rwp', isa => PositiveOrZeroInt, default => sub { 0 });
has whoami => (is => 'rwp', isa => Str, lazy => 1, builder => 1);
has level  => (is => 'rwp', isa => PositiveOrZeroInt, default => sub { 0 });

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

sub BUILD {
  my ($self) = @_;
  #
  # Unless our consumer already have an event on exhaustion,
  # we provide the default one
  #
  $self->callbacks->{'\'exhausted'} //= sub {
    my ($self, $r) = @_;
    $self->debugf('Setting max position to %s', $self->pos);
    $self->max($self->pos);
    $self->pos
  };
}

sub BUILDARGS {
  my ($class, @args) = @_;

  unshift @args, 'input' if (@args % 2 == 1);
  return { @args };
}

sub _build_max {
  my ($self) = @_;

  length($self->input)
}

sub _build_whoami {
  my ($self) = @_;

  return (split(/::/, blessed($self)))[-1]
}

# -----------------------
# General events dispatch
# -----------------------
sub _manageEvents {
  my ($self, $r) = @_;

  my @eventNames = map { $_->[0] } (@{$self->_events($r)});
  $self->tracef('Events: %s', \@eventNames);
  foreach (@eventNames) {
    $self->debugf('--------- %s', $_);
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

  my $r = Marpa::R2::Scanless::R->new({trace_file_handle => $MARPA_TRACE_FILE_HANDLE,
                                       grammar => $self->grammar,
                                       exhaustion => 'event',
                                       trace_terminals => 1,
                                       # trace_actions => 1
                                      });
  $MarpaX::Java::ClassFile::Common::R = $r;

  $self->_read($r);
  while ($self->pos < $self->max) {
    $self->_resume($r)
  }

  $self->_value($r)
}

sub debugf {
  my ($self, $format, @arguments) = @_;

  my $inputLength = length($self->input);
  my $nbcharacters = length("$inputLength");
  $self->_logger->tracef("%s[%*s/%*s] %s: $format", '.' x $self->level, $nbcharacters, $self->pos, $nbcharacters, $self->max, $self->whoami, @arguments)
}

sub tracef {
  my ($self, $format, @arguments) = @_;

  my $inputLength = length($self->input);
  my $nbcharacters = length("$inputLength");
  $self->_logger->tracef("%s[%*s/%*s] %s: $format", '.' x $self->level, $nbcharacters, $self->pos, $nbcharacters, $self->max, $self->whoami, @arguments)
}

sub _croak {
  my ($self, $r, $msg) = @_;
  croak ($msg // '') . "\nContext:\n" . $r->show_progress;
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
  $self->tracef('Parse tree value is %s', $value);
  $value
}

sub _resume {
  my ($self, $r) = @_;
  $self->tracef('$r->resume');
  try {
    $self->_set_pos($r->resume)
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
  $r->literal(@span);
}

sub lexeme_read {
  my ($self, $r, $lexeme_name, $lexeme_pos, $lexeme_length, $lexeme_value) = @_;

  $self->tracef('$r->lexeme_read(name=\'%s\', pos=%s, length=%s, value=%s)', $lexeme_name, $lexeme_pos, $lexeme_length, $lexeme_value);
  try {
    $self->_set_pos($r->lexeme_read($lexeme_name, $lexeme_pos, $lexeme_length, $lexeme_value)) || croak sprintf('lexeme_read failure for symbol %s at position %s, length %s', $lexeme_name, $lexeme_pos // 'undef', $lexeme_length // 'undef')
  } catch {
    $self->_croak($r, $_)
  };
  $self->_manageEvents($r)
}

sub literalU1 {
  my ($self, $r, $symbol) = @_;

  my $u1 = $self->u1($self->_literal($r, $symbol));
  $self->tracef('Got %s=%s', $symbol, $u1);
  $u1
}

sub literalU2 {
  my ($self, $r, $symbol) = @_;

  my $u2 = $self->u2($self->_literal($r, $symbol));
  $self->tracef('Got %s=%s', $symbol, $u2);
  $u2
}

sub literalU3 {
  my ($self, $r, $symbol) = @_;

  my $u4 = $self->u4($self->_literal($r, $symbol));
  $self->tracef('Got %s=%s', $symbol, $u4);
  $u4
}

with qw/MooX::Role::Logger
        MarpaX::Java::ClassFile::Common::Actions
        MarpaX::Java::ClassFile::Common::BNF/;

requires 'callbacks';
requires 'grammar';

1;
