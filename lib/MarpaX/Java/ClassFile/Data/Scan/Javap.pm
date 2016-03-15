use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Data::Scan::Javap;
use Moo;

# ABSTRACT: Data::Scan javap implementation

# VERSION

# AUTHORITY

use MooX::Options protect_argv => 0, flavour => [qw/pass_through/];
use Scalar::Util qw/reftype blessed looks_like_number/;
use Types::Standard -all;
use Types::Common::Numeric -all;
#
# My way of matching only printable ASCII characters
#
my $_ASCII_PRINT = quotemeta(join('', map { chr } (32..126)));
my $_NON_ASCII_PRINT_RE = qr/[^$_ASCII_PRINT]/;

our %ACCESS_FLAG = (
                    ACC_PUBLIC     => 0x0001,
                    ACC_FINAL      => 0x0010,
                    ACC_SUPER      => 0x0020,
                    ACC_INTERFACE  => 0x0200,
                    ACC_ABSTRACT   => 0x0400,
                    ACC_SYNTHETIC  => 0x1000,
                    ACC_ANNOTATION => 0x2000,
                    ACC_ENUM       => 0x4000
                   );

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
has _currentLevel => (is => 'rwp', isa => PositiveOrZeroInt, default => sub { 0 });

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

=head2 Str loglevel

Log level. Should be one of TRACE, DEBUG, INFO, WARN, ERROR. Default is WARN.

=cut

option loglevel => (
                    is => 'ro',
                    isa => Enum[qw/TRACE DEBUG INFO WARN ERROR/],
                    format => 's',
                    doc => 'Log level. Should be one of TRACE, DEBUG, INFO, WARN, ERROR. Default is WARN.',
                    default => sub {
                      return 'WARN'
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

sub dsstart {
}

sub dsopen {
  my ($self, $item) = @_;

  $self->_print(blessed($item));
  $self->_set__currentLevel($self->_currentLevel + 1);
}

sub dsread {
  my ($self, $item) = @_;

  my $blessed = blessed($item);
  if ($blessed && reftype($item) ne 'SCALAR') {
    my $method = $self->can('_' . (split(/::/, $blessed))[-1]);
    if ($method) {
      return $self->$method($item)
    } else {
      return \@{$item}
    }
  } else {
    return $self->_item($item);
  }
}

sub dsclose {
  my ($self) = @_;

  $self->_set__currentLevel($self->_currentLevel - 1);
}

sub dsend {
}

sub _item {
  my ($self, $item) = @_;

  my $blessed = blessed($item);
  if ($blessed) {
    $self->_print('%s %s', $blessed, ${$item});
  } else {
    $self->_print($item // 'undef');
  }
  return
}

sub _ClassFile {
  my ($self, $item) = @_;

  $self->_print('magic               = 0x%x', $item->magic);
  $self->_print('minor version       = %d', $item->minor_version);
  $self->_print('major version       = %d', $item->minor_version);
  my $access_flags = $item->access_flags;
  $self->_print('access flags        = %s',
                 join(', ',
                      grep { ($ACCESS_FLAG{$_} & $access_flags) == $ACCESS_FLAG{$_} }
                      sort { $ACCESS_FLAG{$a} <=> $ACCESS_FLAG{$b} }
                      keys %ACCESS_FLAG));

  return [$item->constant_pool, $item->fields, $item->methods, $item->attributes]
}

sub _print {
  my ($self, $format, @args) = @_;

  my $indent = $self->withindent x $self->_currentLevel;
  my $output = $indent . sprintf($format, @args) . "\n";
  my $handle = $self->handle;
  if (blessed($handle) && $handle->can('print')) {
    $handle->print($output)
  } else {
    print $handle $output
  }
}

with 'Data::Scan::Role::Consumer';

1;
