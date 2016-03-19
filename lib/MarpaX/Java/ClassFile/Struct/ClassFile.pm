use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ClassFile;
use MarpaX::Java::ClassFile::Struct::_Base
  style => 'ARRAY',
  '""' => [
           [ sub { 'magic              ' } => sub { sprintf('0x%0X', $_[0]->magic) } ],
           [ sub { 'version            ' } => sub { sprintf('%d.%d', $_[0]->major_version, $_[0]->minor_version) } ],
           [ sub { 'constant pool count' } => sub { $_[0]->constant_pool_count } ],
           [ sub { 'constant pool      ' } => sub
             {
               #
               # Current recursivity level in OUR stringification routines
               #
               my $currentLevel = $MarpaX::Java::ClassFile::Struct::STRINGIFICATION_LEVEL // 0;
               my $localIndent = '  ' x $currentLevel;
               #
               # To have a pretty printing of indices
               #
               my $maxIndice = $#{$_[0]->constant_pool};
               my $lengthMaxIndice = length($maxIndice);
               #
               # Call for stringification
               #
               my $innerIndent = '  ' . $localIndent;
               my $rc = "[\n" . join(",\n",
                                     map {
                                       #
                                       # Say to any other overload stub that we fake a new level because we
                                       # managed ourself the fact that this is a deployed array
                                       #
                                       local $MarpaX::Java::ClassFile::Struct::STRINGIFICATION_LEVEL = $currentLevel + 1;
                                       sprintf('%s#%*d %s',
                                               $innerIndent,
                                               -$lengthMaxIndice,
                                               $_,
                                               $_[0]->constant_pool->[$_]
                                              )
                                     }
                                     grep { defined($_[0]->constant_pool->[$_]) }  # A cp can be undef
                                     (0..$#{$_[0]->constant_pool})) . "\n$localIndent]";
               $rc
             }
           ]
          ];

# ABSTRACT: struct ClassFile

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 FieldInfo MethodInfo AttributeInfo/;
use Types::Standard qw/ArrayRef InstanceOf/;
use Scalar::Util qw/blessed/;

has magic               => ( is => 'ro', required => 1, isa => U4);
has minor_version       => ( is => 'ro', required => 1, isa => U2);
has major_version       => ( is => 'ro', required => 1, isa => U2);
has constant_pool_count => ( is => 'ro', required => 1, isa => U2);
has constant_pool       => ( is => 'ro', required => 1, isa => ArrayRef);
has access_flags        => ( is => 'ro', required => 1, isa => U2);
has this_class          => ( is => 'ro', required => 1, isa => U2);
has super_class         => ( is => 'ro', required => 1, isa => U2);
has interfaces_count    => ( is => 'ro', required => 1, isa => U2);
has interfaces          => ( is => 'ro', required => 1, isa => ArrayRef[U2]);
has fields_count        => ( is => 'ro', required => 1, isa => U2);
has fields              => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf[FieldInfo]]);
has methods_count       => ( is => 'ro', required => 1, isa => U2);
has methods             => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf[MethodInfo]]);
has attributes_count    => ( is => 'ro', required => 1, isa => U2);
has attributes          => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf[AttributeInfo]]);

my %_ACCESS_FLAG = (
                    ACC_PUBLIC     => 0x0001,
                    ACC_FINAL      => 0x0010,
                    ACC_SUPER      => 0x0020,
                    ACC_INTERFACE  => 0x0200,
                    ACC_ABSTRACT   => 0x0400,
                    ACC_SYNTHETIC  => 0x1000,
                    ACC_ANNOTATION => 0x2000,
                    ACC_ENUM       => 0x4000
);

sub _stringify {
  # my ($self) = @_;

  my $this_class          = sprintf('  Class name         : %s', $_[0]->constant_pool->get($_[0]->this_class));
  my $magic               = sprintf('  Magic number       : 0x%X', $_[0]->magic);
  my $version             = sprintf('  Version            : %d.%d', $_[0]->major_version, $_[0]->minor_version);
  my $access_flags        = sprintf('  Access flags       : %s', join(', ', grep { ($_ACCESS_FLAG{$_} & $_[0]->access_flags) == $_ACCESS_FLAG{$_} } sort { $_ACCESS_FLAG{$a} <=> $_ACCESS_FLAG{$b} } keys %_ACCESS_FLAG));
  my $constant_pool_count = sprintf('  Constant pool count: %d', $_[0]->constant_pool_count - 1);
  my $constant_pool       = do { my $string = $_[0]->constant_pool; $string =~ s/^/  /sxmg; $string }; # Because this is an array, this is multiline
  return <<_TOSTRING;
ClassFile{
$this_class
$magic
$version
$access_flags
$constant_pool_count
$constant_pool
}
_TOSTRING
}

1;
