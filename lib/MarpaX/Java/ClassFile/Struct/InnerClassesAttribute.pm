use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::InnerClassesAttribute;
use Moo;

# ABSTRACT: InnerClasses_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;
use Types::Standard qw/ArrayRef InstanceOf/;

has attribute_name_index   => ( is => 'ro', required => 1, isa => U2 );
has attribute_length       => ( is => 'ro', required => 1, isa => U4 );
has number_of_classes      => ( is => 'ro', required => 1, isa => U2 );
has classes                => ( is => 'ro', required => 1, isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::Struct::Class']] );

1;
