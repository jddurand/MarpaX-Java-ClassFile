use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantInterfaceMethodrefInfo;
use Moo;

# ABSTRACT: CONSTANT_InterfaceMethodref_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has tag                 => ( is => 'ro', isa => U1 );
has class_index         => ( is => 'ro', isa => U2 );
has name_and_type_index => ( is => 'ro', isa => U2 );

1;