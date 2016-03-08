use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Classes;
use Moo;

# ABSTRACT: classes

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has inner_class_info_index   => ( is => 'ro', isa => U2 );
has outer_class_info_index   => ( is => 'ro', isa => U2 );
has inner_name_index         => ( is => 'ro', isa => U2 );
has inner_class_access_flags => ( is => 'ro', isa => U2 );

1;
