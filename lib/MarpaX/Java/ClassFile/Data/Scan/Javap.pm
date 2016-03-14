use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Data::Scan::Javap;
use Moo;
use MooX::Options;

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

use Types::Standard -all;

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

=head2 Str indent

Indentation. Default is '  '.

=cut

option indent => (
                  is => 'ro',
                  isa => Str,
                  doc => 'Indentation. Default is "  ".',
                  format => 's',
                  default => sub {
                    return '  '
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

sub dsstart {}
sub dsopen {}
sub dsread {}
sub dsclose {}
sub dsend {}

with 'Data::Scan::Role::Consumer';

1;
