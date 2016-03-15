use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Data::Scan::Javap;
use Moo;
use MooX::Options protect_argv => 0, flavour => [qw/pass_through/];

use Module::Find;
use Perl::OSType qw/is_os_type/;
my $_HAVE_Win32__Console__ANSI;
BEGIN {
  #
  # Will/Should success only on Win32
  #
  $_HAVE_Win32__Console__ANSI = eval 'use Win32::Console::ANSI; 1;' ## no critic qw/BuiltinFunctions::ProhibitStringyEval/
}
use Scalar::Util qw/reftype blessed looks_like_number/;
use Term::ANSIColor;
use Types::Standard -all;
use Types::Common::Numeric -all;
#
# My way of matching only printable ASCII characters
#
my $_ASCII_PRINT = quotemeta(join('', map { chr } (32..126)));
my $_NON_ASCII_PRINT_RE = qr/[^$_ASCII_PRINT]/;

# ABSTRACT: Data::Scan javap implementation

# VERSION

# AUTHORITY

=head1 DESCRIPTION

MarpaX::Java::ClassFile::Data::Scan::Javap is an implementation of the L<Data::Scan::Role::Consumer> role.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use Data::Scan;
    use MarpaX::Java::ClassFile;
    use MarpaX::Java::ClassFile::Data::Scan::Javap;

    my $classFileName = shift || 'Example.class';
    my $ast = MarpaX::Java::ClassFile->parse($classFileName);
    my $consumer = MarpaX::Java::ClassFile::Data::Scan::Javap->new();
    Data::Scan->new(consumer => $consumer)->process($ast);

=cut

#
# Internal variables
#
has _currentLevel => (is => 'rwp', isa => PositiveOrZeroInt|Undef);
has _colors_cache => (is => 'rwp', isa => Undef|HashRef[Str|Undef]);


=head1 CONSTRUCTOR OPTIONS

Here the list of supported options, every name is preceded by its type.

=cut

=head2 FileHandle handle

Handle for the output. Default is \*STDOUT.

=cut

has handle => (
               is => 'ro',
               isa => FileHandle,
               default => sub {
                 return \*STDOUT
               }
              );

=head2 Bool verbose

Verbose mode. Default is a false value.

=cut

option verbose => (
                   is => 'ro',
                   isa => Bool,
                   short => 'v',
                   doc => 'Verbose mode. Default is a false value.',
                   default => sub {
                     return 0
                  }
                 );

=head2 Bool local

Verbose mode. Default is a false value.

=cut

option local => (
                 is => 'ro',
                 isa => Bool,
                 short => 'l',
                 doc => 'Line number and local variable tables. Default is a false value.',
                 default => sub {
                   return 0
                 }
                );

=head2 Bool public

Show only public classes and members. Default is a false value.

=cut

option public => (
                  is => 'ro',
                  isa => Bool,
                  doc => 'Show only public classes and members. Default is a false value.',
                  default => sub {
                    return 0
                  }
                 );

=head2 Bool protected

Show protected/public classes and members. Default is a false value.

=cut

option protected => (
                     is => 'ro',
                     isa => Bool,
                     doc => 'Show protected/public classes and members. Default is a false value.',
                     default => sub {
                       return 0
                     }
                    );

=head2 Bool package

Show package/protected/public classes and members. Default is a true value.

=cut

option package => (
                   is => 'ro',
                   isa => Bool,
                   short => 'p',
                   doc => 'Show package/protected/public classes and members. Default is a false value.',
                   default => sub {
                     return 1
                   }
                  );

=head2 Bool code

Show the code. Default is a false value.

=cut

option code => (
                is => 'ro',
                isa => Bool,
                short => 'c',
                doc => 'Show the code. Default is a false value.',
                default => sub {
                  return 0
                }
               );

=head2 Bool signature

Show internal type signatures. Default is a false value.

=cut

option signature => (
                     is => 'ro',
                     isa => Bool,
                     short => 's',
                     doc => 'Show internal type signatures. Default is a false value.',
                     default => sub {
                       return 0
                     }
                    );

=head2 Bool constants

Show static final constants. Default is a false value.

=cut

option constants => (
                     is => 'ro',
                     isa => Bool,
                     doc => 'Show static final constants. Default is a false value.',
                     default => sub {
                       return 0
                     }
                    );

=head2 Str withindent

Indentation. Default is '  '.

=cut

option withindent => (
                      is => 'ro',
                      isa => Str,
                      doc => 'Indentation. Default is "  ".',
                      format => 's',
                      default => sub {
                        return '  '
                      }
                 );

=head2 Bool withutf8output

Say if handle is capable to print UTF-8 characters. When it is not, any character outside of ASCII, or being a control character, will be escaped to "\\x{codepointer}". Default is a false  value.

=cut

option withutf8output => (
                     is => 'ro',
                     isa => Bool,
                     doc => 'Say if your terminal is capable to print UTF-8 characters. When it is not, any character outside of ASCII, or being a control character, will be escaped to "\\x{codepointer}". Default is a false  value',
                     default => sub { 0 });

=head2 Bool withcolor

Use ANSI colors. Default is a false value if $ENV{ANSI_COLORS_DISABLED} exists, else a true value if $ENV{ANSI_COLORS_ENABLED} exists, else a false value if L<Win32::Console::ANSI> cannot be loaded and you are on Windows, else a true value.

=cut

my $_canColor = __PACKAGE__->_canColor;

option withcolor => (
                     is => 'ro',
                     isa => Bool,
                     negativable => 1,
                     doc => 'ANSI colorized output. Option is ngativable with --nowithcolor. Default is a ' . ($_canColor ? 'true' : 'false') . ' value.',
                     default => sub { return $_canColor });

=head2 Bool withdefcolor

Definition of ANSI colors.

=cut

my @struct =
  sort
  map { (split(/::/, $_))[-1] }
  grep { /::[A-Z][^:]*$/}
  findallmod('MarpaX::Java::ClassFile::Struct');

my $_DEFCOLOR =
  '{' .
  join(',',
       '"ConstantUtf8Info":green',
       '"CodeAttribute":yellow'
      )
  . '}';
option withdefcolor => (
                        is => 'ro',
                        json => 1,
                        doc => "ANSI color definition. Form is a JSON string.\n\n    Supported keys are: " . join(', ', @struct) . "\n\n    Default is: $_DEFCOLOR.",
                        default => sub { return {} });

sub dsstart {
  print STDERR "DSSTART " . join(' ', map { $_ // '<undef>'} @_[1..$#_]) . "\n";
  my ($self) = @_;

  $self->_set__currentLevel(0);
  #
  # Precompute color attributes
  #
  $self->_set__colors_cache({});
  if ($self->withcolor) {
    foreach (keys %{$self->withdefcolor}) {
      my $color = $self->withdefcolor->{$_};
      if (defined($color)) {
        my $colored = colored('dummy', $color);
        #
        # ANSI color spec is clear: attributes before the string, followed by
        # the string, followed by "\e[0m". We do not support the eventual
        # $EACHLINE hack.
        #
        if ($colored =~ /(.+)dummy\e\[0m$/) {
          $self->{_colors_cache}->{$_} = substr($colored, $-[1], $+[1] - $-[1])
        } else {
          $self->{_colors_cache}->{$_} = undef
        }
      } else {
        $self->{_colors_cache}->{$_} = undef
      }
    }
  } else {
    foreach (keys %{$self->colors}) {
      $self->{_colors_cache}->{$_} = undef
    }
  }
}

sub dsopen {
  print STDERR "DSOPEN " . join(' ', map { $_ // '<undef>'} @_[1..$#_]) . "\n";
  my ($self, $item) = @_;

  $self->_set__currentLevel($self->_currentLevel + 1);
}

sub dsread {
  print STDERR "DSREAD " . join(' ', map { $_ // '<undef>'} @_[1..$#_]) . "\n";
  my ($self, $item) = @_;

  my $blessed = blessed($item) // '';
  my $struct = (split(/::/, $blessed))[-1] // '';
  my $method = length($struct) ? $self->can("_$struct") : undef;

  if ($method) {
    return $self->$method($item)
  } else {
    return $self->_dsread($item)
  }
}

sub dsclose {
  print STDERR "DSCLOSE " . join(' ', map { $_ // '<undef>'} @_[1..$#_]) . "\n";
  my ($self) = @_;

  $self->_set__currentLevel($self->_currentLevel - 1);
}

sub dsend {
  print STDERR "DSEND " . join(' ', map { $_ // '<undef>'} @_[1..$#_]) . "\n";
  my ($self) = @_;

  $self->_set__currentLevel(undef);
  $self->_set__colors_cache(undef);
}

sub _dsread {
  my ($self, $item) = @_;

  my $blessed = blessed($item) // '';
  my $reftype = reftype($item) // '';

  my @rc = ();
  if ($reftype eq 'SCALAR') {
    $self->_print([$blessed, "%s %s", $blessed, ${$item}]);
  } elsif ($reftype eq 'HASH') {
    $self->_print([$blessed, "%s", $blessed]);
    @rc = sort keys %{$item};
  } elsif ($reftype eq 'ARRAY') {
    $self->_print([$blessed, "%s", $blessed]);
    @rc = @{$item};
  }

  \@rc
}

sub _ClassFile {
  my ($self, $item) = @_;

  $self->_print(['', 'magic               = 0x%x', $item->magic]);
  $self->_print(['', 'minor version       = %d', $item->minor_version]);
  $self->_print(['', 'major version       = %d', $item->minor_version]);
  $self->_print(['', 'access flags        = %d', $item->access_flags]);

  return [$item->constant_pool, $item->fields, $item->methods, $item->attributes]
}

sub _canColor {
  my ($class) = @_;
  #
  # Mimic Data::Printer use of $ENV{ANSI_COLORS_DISABLED}
  #
  return 0 if exists($ENV{ANSI_COLORS_DISABLED});
  #
  # Add the support of ANSI_COLORS_ENABLED
  #
  return 1 if exists($ENV{ANSI_COLORS_ENABLED});
  #
  # that has precedence on the Windows check, returning 0 if we did not load Win32::Console::ANSI
  #
  return 0 if (is_os_type('Windows') && ! $_HAVE_Win32__Console__ANSI);
  return 1
}

sub _colored {
  my ($self, $what, $fmt, @args) = @_;

  my $desc = sprintf($fmt, @args);

  if (! $self->withutf8output) {
    #
    # Detect any non ANSI character and enclose result within ""
    #
    $desc =~ s/$_NON_ASCII_PRINT_RE/sprintf('\\x{%x}', ord(${^MATCH}))/egpo;
  }
  if ($self->withcolor) {
    #
    # We know that _colors_cache is a HashRef, and that _lines is an ArrayRef
    #
    my $color_cache = $self->{_colors_cache}->{$what};  # Handled below if it does not exist or its value is undef
    $desc = $color_cache . $desc . "\e[0m" if (defined($color_cache))
  }

  $desc
}

sub _print {
  my ($self, @desc) = @_;

  my $indent = $self->withindent x $self->_currentLevel;
  my $output = $indent . join('', map { $self->_colored(@{$_}) } @desc) . "\n";
  my $handle = $self->handle;
  if (blessed($handle) && $handle->can('print')) {
    $handle->print($output)
  } else {
    print $handle $output
  }
}

with 'Data::Scan::Role::Consumer';

1;
