use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::FullFrame;
use Moo;

# ABSTRACT: full_frame

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has frame_type            => ( is => 'ro', required => 1, isa => U1 );
has offset_delta          => ( is => 'ro', required => 1, isa => U2 );
has number_of_locals      => ( is => 'ro', required => 1, isa => U2 );
has locals                => ( is => 'ro', required => 1, isa => ArrayRef[VerificationTypeInfo] );
has number_of_stack_items => ( is => 'ro', required => 1, isa => U2 );
has stack                 => ( is => 'ro', required => 1, isa => ArrayRef[VerificationTypeInfo] );

1;
