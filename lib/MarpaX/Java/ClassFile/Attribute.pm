use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Attribute;

# ABSTRACT: Java .class's attribute_info object

# VERSION

# AUTHORITY

use Moo;
use Types::Common::Numeric qw/PositiveInt PositiveOrZeroInt/;
use Types::Encodings qw/Bytes/;
use Types::Standard qw/InstanceOf/;

has classFile            => ( is => 'ro', isa => InstanceOf['MarpaX::Java::ClassFile'], required => 1, weak_ref => 1 ); # weak ref
has attribute_name_index => ( is => 'ro', isa => PositiveInt,                                          required => 1 );
has attribute_length     => ( is => 'ro', isa => PositiveOrZeroInt,                                    required => 1 );
has info                 => ( is => 'ro', isa => Bytes,                                                required => 1 );

1;
