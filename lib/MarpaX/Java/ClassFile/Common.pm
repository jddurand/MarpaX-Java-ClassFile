use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Common;
use Moo::Role;

use Carp qw/croak/;
use MarpaX::Java::ClassFile::Actions;
use MarpaX::Java::ClassFile::MarpaTrace;
use Data::Section -setup;
use Types::Common::Numeric -all;
use Types::Standard -all;
use Types::Encodings qw/Bytes/;
use Try::Tiny;

has input => (is => 'ro',  isa => Bytes, required => 1);
has ast   => (is => 'rwp', isa => Any);
has pos   => (is => 'rwp', isa => PositiveOrZeroInt, default => sub { 0 });
has max   => (is => 'rwp', isa => PositiveOrZeroInt, lazy => 1, builder => 1);

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
  $self->_logger->debugf('[%s/%s] %s is starting', $self->pos, $self->max, ref($self));
  $self->callbacks->{'\'exhausted'} //= sub {
    my ($self, $r) = @_;
    $self->_logger->debugf('[%s/%s] Setting max position to %s', $self->pos, $self->max, $self->pos);
    $self->_set_max($self->pos);
    $self->pos
  };
  $self->_parse
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

# -----------------------
# General events dispatch
# -----------------------
sub _manageEvents {
  my ($self, $r) = @_;

  my @eventNames = map { $_->[0] } (@{$self->_events($r)});
  $self->_logger->tracef('[%s/%s] Events: %s', $self->pos, $self->max, \@eventNames);
  foreach (@eventNames) {
    my $callback = $self->callbacks->{$_};
    croak "Internal error, unknown event $_" unless defined($callback);
    $self->_logger->debugf('[%s/%s] --------- %s', $self->pos, $self->max, $_);
    $self->_set_pos($self->$callback($r));
  }
}

sub _parse {
  my ($self) = @_;

  #
  # For our marpa tied logger
  #
  local $MarpaX::Java::ClassFile::Common::SELF = $self;
  local $MarpaX::Java::ClassFile::Common::R    = undef;

  my $r = Marpa::R2::Scanless::R->new({trace_file_handle => $MARPA_TRACE_FILE_HANDLE,
                                       semantics_package => 'MarpaX::Java::ClassFile::Actions',
                                       grammar => $self->grammar,
                                       exhaustion => 'event',
                                       trace_terminals => 1,
                                       trace_actions => 1
                                      });
  $MarpaX::Java::ClassFile::Common::R = $r;

  for ($self->_read($r); $self->pos < $self->max; $self->_resume($r)) {
    $self->_manageEvents($r)
  }

  $self->_set_ast($self->_value($r))
}

sub _croak {
  my ($self, $r, $msg) = @_;
  croak ($msg // '') . "\nContext:\n" . $r->show_progress;
}

sub _read {
  my ($self, $r) = @_;
  $self->_logger->tracef('[%s/%s] read($inputRef, pos=%s)', $self->pos, $self->max, $self->pos);
  try {
    $self->_set_pos($r->read(\$self->input, $self->pos))
  } catch {
    $self->_croak($r, $_)
  };
  - $self->pos
}

sub _events {
  my ($self, $r) = @_;
  $self->_logger->tracef('[%s/%s] events()', $self->pos, $self->max);
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
  $self->_logger->tracef('[%s/%s] ambiguity_metric()', $self->pos, $self->max);
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

  $self->_logger->tracef('[%s/%s] value($self)', $self->pos, $self->max);
  my $valueRef;
  try {
    $valueRef = $r->value($self)
  } catch {
    $self->_croak($r, $_)
  };
  $self->_croak($r, 'Value reference is undefined') if (! defined($valueRef));
  my $value = ${$valueRef};
  $self->_logger->tracef('[%s/%s] value is %s', $self->pos, $self->max, $value);
  $value
}

sub _resume {
  my ($self, $r) = @_;
  $self->_logger->tracef('[%s/%s] resume', $self->pos, $self->max);
  try {
    $self->_set_pos($r->resume)
  } catch {
    $self->_croak($r, $_)
  };
  - $self->pos
}

sub literal {
  my ($self, $r, $symbol) = @_;
  my @span = $r->last_completed_span($symbol);
  $self->_croak($r, "No symbol instance for the symbol $symbol") if (! @span);
  $r->literal(@span);
}

sub lexeme_read {
  my ($self, $r, $lexeme_name, $lexeme_pos, $lexeme_length, $lexeme_value) = @_;

  $self->_logger->tracef('[%s/%s] lexeme_read(name=%s, pos=%s, length=%s, value=%s)', $self->pos, $self->max, $lexeme_name, $lexeme_pos, $lexeme_length, $lexeme_value);
  try {
    $self->_set_pos($r->lexeme_read($lexeme_name, $lexeme_pos, $lexeme_length, $lexeme_value)) || croak sprintf('lexeme_read failure for symbol %s at position %s, length %s', $lexeme_name, $lexeme_pos // 'undef', $lexeme_length // 'undef')
  } catch {
    $self->_croak($r, $_)
  };
  - $self->pos
}

sub u1 {
  my ($self, $r, $symbol) = @_;

  my $u1 = MarpaX::Java::ClassFile::Actions->u1($self->literal($r, $symbol));
  $self->_logger->tracef('[%s/%s] %s value is %s', $self->pos, $self->max, $symbol, $u1);
  $u1
}

sub u2 {
  my ($self, $r, $symbol) = @_;

  my $u2 = MarpaX::Java::ClassFile::Actions->u2($self->literal($r, $symbol));
  $self->_logger->tracef('[%s/%s] %s value is %s', $self->pos, $self->max, $symbol, $u2);
  $u2
}

sub u4 {
  my ($self, $r, $symbol) = @_;

  my $u4 = MarpaX::Java::ClassFile::Actions->u4($self->literal($r, $symbol));
  $self->_logger->tracef('[%s/%s] %s value is %s', $self->pos, $self->max, $symbol, $u4);
  $u4
}

with 'MooX::Role::Logger';

requires 'callbacks';
requires 'grammar';

1;

__DATA__
__[ bnf_top ]__
:default ::= action => [values]
lexeme default = latm => 1
inaccessible is ok by default

__[ bnf_bottom ]__
########################################
#           Common rules               #
########################################
u1      ::= U1                 action => u1
u2      ::= U2                 action => u2
u4      ::= U4                 action => u4
managed ::= MANAGED            action => ::first

# ----------------
# Internal Lexemes
# ----------------
_U1      ~ [\s\S]
_U2      ~ _U1 _U1
_U4      ~ _U2 _U2
_MANAGED ~ [^\s\S]

########################################
#          Common lexemes              #
########################################
U1      ~ _U1
U2      ~ _U2
U4      ~ _U4
MANAGED ~ _MANAGED
