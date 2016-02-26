use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::MarpaTrace;
use MooX::Role::Logger;

use Class::Load qw/is_class_loaded/;

# ABSTRACT: Marpa Trace Wrapper

# VERSION

# AUTHORITY

sub BEGIN {
  #
  ## Some Log implementation specificities
  #
  Log::Log4perl->wrapper_register(__PACKAGE__) if (is_class_loaded('Log::Log4perl'))
}

sub TIEHANDLE {
  bless {}, $_[0]
}

sub PRINT {
  my $self = $MarpaX::Java::ClassFile::Common::SELF;

  my $r                = $MarpaX::Java::ClassFile::Common::R;
  my ($start, $length);
  if (defined($r)) {
    my $g1 = $r->current_g1_location();
    ($start, $length) = $r->g1_location_to_span($g1);
  }

  #
  # We do not want to be perturbed by automatic thingies coming from $\
  #
  local $\ = undef;
  if (defined($r)) {
    map { $self->_logger->tracef('[%s->%s/%s] %s', $start, $start + $length, $self->max, $_) } split(/\n/, join('', @_[1..$#_]));
  } else {
    map { $self->_logger->tracef('[%s/%s] %s', $self->pos, $self->max, $_) } split(/\n/, join('', @_[1..$#_]));
  }
  1
}

sub PRINTF {
  $_[0]->PRINT(sprintf(shift, @_[1..$#_]));
  1
}

1;
