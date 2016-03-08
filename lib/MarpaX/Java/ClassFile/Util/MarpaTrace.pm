use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Util::MarpaTrace;
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
  no warnings 'once';
  my $self = $MarpaX::Java::ClassFile::Role::Parser::SELF;
  #
  # This is supported only if this localized variable is set
  #
  if ($self) {
    #
    # We do not want to be perturbed by automatic thingies coming from $\
    #
    local $\ = undef;
    map { $self->tracef('%s', $_) } split(/\n/, join('', @_[1..$#_]));
  }
  1
}

sub PRINTF {
  $_[0]->PRINT(sprintf(shift, @_[1..$#_]));
  1
}

1;
