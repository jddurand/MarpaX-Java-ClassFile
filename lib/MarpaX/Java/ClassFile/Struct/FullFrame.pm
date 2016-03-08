use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::FullFrame ;
use Moo;

# ABSTRACT: full_frame

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has frame_type            => ( is => 'ro', isa => U1 );
has offset_delta          => ( is => 'ro', isa => U2 );
has number_of_locals      => ( is => 'ro', isa => U2 );
has locals                => ( is => 'ro', isa => ArrayRef[VerificationTypeInfo] );
has number_of_stack_items => ( is => 'ro', isa => U2 );
has stack                 => ( is => 'ro', isa => ArrayRef[VerificationTypeInfo] );

1;