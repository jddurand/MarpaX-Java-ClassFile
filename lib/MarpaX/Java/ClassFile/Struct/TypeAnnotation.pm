use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypeAnnotation;
use Moo;

# ABSTRACT: type_annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has target_type              => ( is => 'ro', isa => U1 );
has target_info              => ( is => 'ro', isa => TargetInfo );
has target_path              => ( is => 'ro', isa => TypePath );
has type_index               => ( is => 'ro', isa => U2 );
has num_element_value_pairs  => ( is => 'ro', isa => U2 );
has element_value_pairs      => ( is => 'ro', isa => ArrayRef[ElementValuePair] );
1;
