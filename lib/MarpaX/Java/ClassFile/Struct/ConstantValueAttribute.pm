use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantValueAttribute;
use Moo;

# ABSTRACT: ConstantValue_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;

has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has constantvalue_index   => ( is => 'ro', required => 1, isa => U2 );

1;
