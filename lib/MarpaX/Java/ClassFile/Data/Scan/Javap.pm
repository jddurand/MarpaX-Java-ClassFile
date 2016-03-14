use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Data::Scan::Javap;
use Moo;
use MooX::Options;
use Perl::OSType qw/is_os_type/;
my $_HAVE_Win32__Console__ANSI;
BEGIN {
  #
  # Will/Should success only on Win32
  #
  $_HAVE_Win32__Console__ANSI = eval 'use Win32::Console::ANSI; 1;' ## no critic qw/BuiltinFunctions::ProhibitStringyEval/
}
use Term::ANSIColor;
use Types::Standard -all;
use Types::Common::Numeric -all;

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
has _currentLevel => (is => 'rwp', isa => PositiveOrZeroInt);


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

my $_DEFCOLOR='{"a":1,"b":2}';
option withdefcolor => (
                        is => 'ro',
                        json => 1,
                        doc => "ANSI color definition. Form is a JSON string. Default is $_DEFCOLOR.",
                        default => sub { return {} });

sub dsstart {
  my ($self) = @_;

  $self->_set__currentLevel(0);
}

sub dsopen {}
sub dsread {}
sub dsclose {}
sub dsend {}

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

with 'Data::Scan::Role::Consumer';

1;
