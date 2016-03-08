use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::InnerClassesAttribute;
use Moo;

# ABSTRACT: InnerClasses_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index   => ( is => 'ro', isa => U2 );
has attribute_length       => ( is => 'ro', isa => U4 );
has number_of_classes      => ( is => 'ro', isa => U2 );
has classes                => ( is => 'ro', isa => ArrayRef[Classes] );

1;
