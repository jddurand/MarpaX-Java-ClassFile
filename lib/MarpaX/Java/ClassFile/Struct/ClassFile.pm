use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ClassFile;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Util::AccessFlagsStringification qw/accessFlagsStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Magic              ' } => sub { sprintf('0x%0X', $_[0]->magic) } ],
           [ sub { 'Version            ' } => sub { sprintf('%d.%d', $_[0]->major_version, $_[0]->minor_version) } ],
           [ sub { 'Constant pool count' } => sub { $_[0]->constant_pool_count } ],
           [ sub { 'Constant pool      ' } => sub { $_[0]->arrayStringificator($_[0]->constant_pool) } ],
           [ sub { 'Access flags       ' } => sub { $_[0]->accessFlagsStringificator($_[0]->access_flags) } ]
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

1;
