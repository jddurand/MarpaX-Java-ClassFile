use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;
use Moo;

# ABSTRACT: Java .class parsing

# VERSION

# AUTHORITY

use Types::Common::Numeric qw/PositiveOrZeroInt/;
use Types::Standard -all;

has magic               => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has minor_version       => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has major_version       => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has constant_pool_count => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has constant_pool       => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::ConstantPool']|Undef]);
has access_flags        => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has this_class          => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has super_class         => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has interfaces_count    => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has interfaces          => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Interface']]);
has fields_count        => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has fields              => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Field']]);
has methods_count       => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has methods             => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Method']]);
has attributes_count    => ( is => 'ro', required => 1, isa => PositiveOrZeroInt);
has attributes          => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Attribute']]);

1;
