use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::InnerClassesAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool attribute_name_index attribute_length number_of_classes classes/],
  '""' => [
           [ sub { 'Classes count'                                 } => sub { $_[0]->number_of_classes } ],
           [ sub { 'Classes'                                       } => sub { $_[0]->arrayStringificator($_[0]->classes) } ]
          ];

# ABSTRACT: InnerClasses_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;
use Types::Standard qw/ArrayRef InstanceOf/;

has _constant_pool         => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index   => ( is => 'ro', required => 1, isa => U2 );
has attribute_length       => ( is => 'ro', required => 1, isa => U4 );
has number_of_classes      => ( is => 'ro', required => 1, isa => U2 );
has classes                => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Struct::Class']] );

1;
