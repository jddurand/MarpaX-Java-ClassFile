use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantNameAndTypeInfo;
use Moo;

# ABSTRACT: CONSTANT_NameAndType_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;

has tag              => ( is => 'ro', required => 1, isa => U1 );
has name_index       => ( is => 'ro', required => 1, isa => U2 );
has descriptor_index => ( is => 'ro', required => 1, isa => U2 );

1;
