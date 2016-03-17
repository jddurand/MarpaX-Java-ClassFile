use strict;
use warnings FATAL => 'all';

#
# MarpaX::Java::ClassFile is doing a LOT of new().
# In development/author phases it is ok to do type checkings,
# but in production mode, this is too expensive, so we go
# back to the old style. In addition, I want objects to
# "look like" a C structure and ALWAYS READ-ONLY.
#
# This module, when running in production mode, creates
# an object that, when inspected via dumper modules, will
# truely look like an array with read-only accessors.
#
# We se a trick specific to our implementation: SCALAR references
# never exist in input to new(). We fake a SCALAR reference when needed,
# just to have something pretty in dumper modules.
#

package MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: Base class for all structure - optimized to a very basic array-based object in production mode

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Import::Into;
use Class::Method::Modifiers qw/install_modifier/;
use Scalar::Util qw/reftype blessed/;
use Import::Into;
use Data::Dumper;
require Moo;

my %_HAS_TRACKED = ();
my @_GETTER = ();

sub import {
  my $target = caller;

  if ($ENV{AUTHOR_TESTING}) {
    #
    # Import Moo into caller
    #
    Moo->import::into($target);
  } else {
    #
    # Our version of 'has'. We support only that.
    #
    install_modifier($target, 'fresh', has => sub { _has($target, @_) } );
    #
    # And our version of 'new'.
    #
    install_modifier($target, 'fresh', new => sub { _new($target, @_) } )
  }
  #
  # In any case, inject the toString method unless class already provide this
  #
  install_modifier($target, 'fresh', toString => sub { goto &_toString } ) unless ($target->can('toString'))
}

sub _has {
  my $target = shift;
  my $name = shift;
  my @proto = ((reftype($name) //'') eq 'ARRAY') ? @{$name} : $name;
  #
  # No check, will carp naturally if this does not expand to a hash
  #
  my %spec = @_;
  #
  # Keep track of members as the 'has' appears
  #
  my $has_tracked = $_HAS_TRACKED{$target} //= {};
  foreach my $proto (@proto) {
    next if (exists($has_tracked->{$proto}));
    #
    # Member not yet registered
    #
    my $proto_indice = scalar(keys %{$has_tracked});
    $has_tracked->{$proto} = $proto_indice;
    #
    # We do NO CHECK whatever on 'is', 'isa', etc...
    # Everything is assumed to be a mutator eventually initalized at new() time.
    # There is NO type checking - full point.
    #
    # Oh, our new() ensures everything is a reference, so reftype() always return a non-null value.
    #
    $_GETTER[$proto_indice] //= eval "sub { \$_[0]->[$proto_indice] = \$_[1] if (\$#_); my \$value = \$_[0]->[$proto_indice]; (Scalar::Util::reftype(\$value) eq 'SCALAR') ? \${\$value} : \$value }" || croak $@;
    install_modifier($target, 'fresh', $proto => $_GETTER[$proto_indice])
  }
}

sub _new {
  my ($target, $class, %args) = @_;

  my $has_tracked = $_HAS_TRACKED{$target};
  my @array = ();
  foreach my $proto (keys %{$has_tracked}) {
    my $value = $args{$proto};
    my $indice = $has_tracked->{$proto};
    #
    # NO type checking nor safety checking
    #
    if (blessed($value)) {
      $array[$indice] = $args{$proto}
    } else {
      #
      # scalars are explicitely stored as a reference (i.e. ref() will return 'SCALAR'
      #
      if (ref($value)) {
        $array[$indice] = bless($value, $proto)
      } else {
        $array[$indice] = bless(\$value, $proto)
      }
    }
  }
  #
  # In conclusion...: reftype() will never return a null value
  #
  bless(\@array, $class)
}

sub _toString {
  my ($self) = @_;
  #
  # The presence of a _perlvalue always have precedence
  #
  my $_perlvalue = $self->can('_perlvalue');
  my $value = $_perlvalue ? $self->_perlvalue : $self;
  #
  # In case of real OO thingy, we are lazy and let Data::Dumper do the job
  #
  return Dumper($value) if ($ENV{AUTHOR_TESTING});
  #
  # Do heuristic based on members
  #
  my $has_tracked = $_HAS_TRACKED{blessed($self)};
  my @string = ();
  #
  # Eventual indentation
  #
  my $indent = $MarpaX::Java::ClassFile::Struct::_Base::INDENT // 0;
  #
  # Loop on members sorted by indice
  #
  foreach my $proto (sort { $has_tracked->{$a} <=> $has_tracked->{$b} } keys %{$has_tracked}) {
    $value = $self->$proto;

    my $blessed = blessed($value);
    if (! $blessed) {
      push(@string, "$proto: " . ($value // ''));
    } else {
      my $toString = $value->can('toString');
      if ($toString) {
        push(@string, "$proto: " . $value->$toString)
      } else {
        #
        # Then, it is always an array reference in our model
        #
        my @array = ();
        foreach (@{$value}) {
          #
          # An array member is either blessed either a scalar
          #
          if (blessed($_)) {
            local $MarpaX::Java::ClassFile::Struct::_Base::INDENT = $indent + 1;
            push(@array, $_->toString)
          } else {
            push(@array, $_ // '')
          }
        }
        push(@string, "$proto: [" . join(",\n", @array) . "]");
      }
    }
  }
  my $indentToString = (' ' x $indent);
  return $indentToString . join("\n$indentToString", @string) . "\n"
}

1;
