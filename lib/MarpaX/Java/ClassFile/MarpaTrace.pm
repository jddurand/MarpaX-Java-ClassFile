use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::MarpaTrace;
use MooX::Role::Logger;

use Class::Load qw/is_class_loaded/;

# ABSTRACT: Marpa Trace Wrapper

# VERSION

# AUTHORITY

=head1 DESCRIPTION

MarpaX::Java::ClassFile::MarpaTrace is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

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
  #
  # We do not want to be perturbed by automatic thingies coming from $\
  #
  local $\ = undef;
  map { $self->tracef('%s', $_) } split(/\n/, join('', @_[1..$#_]));
  1
}

sub PRINTF {
  $_[0]->PRINT(sprintf(shift, @_[1..$#_]));
  1
}

1;
