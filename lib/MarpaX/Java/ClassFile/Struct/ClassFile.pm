use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ClassFile;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: struct ClassFile

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 CpInfo FieldInfo MethodInfo AttributeInfo/;
use Types::Standard qw/ArrayRef InstanceOf/;
use Scalar::Util qw/blessed/;

has magic               => ( is => 'ro', required => 1, isa => U4);
has minor_version       => ( is => 'ro', required => 1, isa => U2);
has major_version       => ( is => 'ro', required => 1, isa => U2);
has constant_pool_count => ( is => 'ro', required => 1, isa => U2);
has constant_pool       => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf[CpInfo]]);
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

  my $this_class          = sprintf('Class name         : %s', $_[0]->constant_pool->[$_[0]->this_class]);
  my $magic               = sprintf('Magic number       : 0x%X', $_[0]->magic);
  my $version             = sprintf('Version            : %d.%d', $_[0]->major_version, $_[0]->minor_version);
  my $access_flags        = sprintf('Access flags       : %s', join(', ', grep { ($_ACCESS_FLAG{$_} & $_[0]->access_flags) == $_ACCESS_FLAG{$_} } sort { $_ACCESS_FLAG{$a} <=> $_ACCESS_FLAG{$b} } keys %_ACCESS_FLAG));
  my $constant_pool_count = sprintf('Constant pool count: %d', $_[0]->constant_pool_count);
  my $constant_pool       = sprintf("Constant pool      :\n%s",
                                    join("\n",
                                         map { s/^/    /sxmg; $_ }
                                         map { sprintf('#%d %s', $_, $_[0]->constant_pool->[$_]) }
                                         grep { blessed($_[0]->constant_pool->[$_]) } (1..$_[0]->constant_pool_count-1)
                                        )
                                   );
  return <<_TOSTRING;
ClassFile:
  $this_class
  $magic
  $version
  $access_flags
  $constant_pool_count
  $constant_pool
_TOSTRING
}

1;
