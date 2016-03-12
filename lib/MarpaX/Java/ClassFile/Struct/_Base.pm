use strict;
use warnings FATAL => 'all';

#
# MarpaX::Java::ClassFile is doing a LOT of new().
# In development/author phases it is ok to do type checkings,
# but in production mode, this is too expensive, so we go
# back to the old style. In addition, I want objects to
# "look like" a C structure.
# This module, when running in production mode, creates
# an object that, when inpsected via dumper modules, will
# truely look like an array.
# This CANNOT be generalized: we use a trick specific to
# our implementation: SCALAR references never exist in input to new().
# we fake a SCALAR reference when needed, just to have
# something pretty in dumper modules.
#

package MarpaX::Java::ClassFile::Struct::_Base;
use Carp qw/croak/;
use if   $ENV{AUTHOR_TESTING}, 'Moo';
use Scalar::Util qw//;
use namespace::sweep;

my $_CONSTRUCTOR_HEADER = <<'CONSTRUCTOR_HEADER';
my ($class, %input) = @_;
bless([
CONSTRUCTOR_HEADER

my $_CONSTRUCTOR_TRAILER = <<'CONSTRUCTOR_TRAILER';
], $class)
CONSTRUCTOR_TRAILER

sub make_me {
  my ($class, @has) = @_;
  #
  # We want keys to be in the same order as the input to this
  # routine, this is why we unpacked @_ to @has and not %has
  #
  # Get the hash
  #
  my %has = @has;
  #
  # Get ordered keys
  #
  my @keys = ();
  while (@has) {
    push(@keys, shift(@has));
    shift(@has);
  }
  if ($ENV{AUTHOR_TESTING}) {
    #
    # In author testing mode, we use the model below OO implementation.
    # Always as hash AFAIK. Values of %has must be references to a hash.
    #
    map { has($_, %{$has{$_}}) } @keys
  } else {
    no strict 'refs';
    #
    # In prod mode, we use the fastest mode I know:
    # array style (good because this is how we expect structure members
    # to appear) and no type checking. You can think to Class::Accessor::Faster
    # though this is not exactly the same here -;
    #
    # -----------
    # Constructor
    # -----------
    my @CONSTRUCTOR = ($_CONSTRUCTOR_HEADER,
                       #
                       # See: EVERYTHING is blessed:
                       # - references are kepts as is
                       # - Scalars are blessed their key name
                       # We know by construction that we hever have references to SCALAR in input
                       # this is why it is ok.
                       #
                       join(",\n", map { "  do {
                                                 my \$value = \$input{$keys[$_]};
                                                 ref(\$value) ? \$value : bless(\\\$value, '$keys[$_]')
                                               }" } (0..$#keys)),
                       $_CONSTRUCTOR_TRAILER);
    my $CONSTRUCTOR = join("\n", @CONSTRUCTOR);
    *{"${class}::new"} = eval "sub { $CONSTRUCTOR }" || croak $@;
    #
    # -------
    # Getters
    # ---------
    #
    # If the value is a reference to a scalar, this is mean that in input it was an unblessed scalar
    #
    map { *{"${class}::$keys[$_]"} = eval "sub { my \$value = \$_[0]->[$_]; (Scalar::Util::reftype(\$value) ne 'SCALAR') ? \$value : \${\$value} }" || croak $@ } (0..$#keys);
  }

}

1;
