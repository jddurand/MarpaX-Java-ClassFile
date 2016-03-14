use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::EnclosingMethodAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: EnclosingMethod_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;

has attribute_name_index   => ( is => 'ro', required => 1, isa => U2 );
has attribute_length       => ( is => 'ro', required => 1, isa => U4 );
has class_index            => ( is => 'ro', required => 1, isa => U2 );
has method_index           => ( is => 'ro', required => 1, isa => U2 );

1;
