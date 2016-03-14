use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::TypeAnnotation;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: type_annotation

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 TargetInfo TypePath ElementValuePair/;
use Types::Standard qw/ArrayRef/;

has target_type              => ( is => 'ro', required => 1, isa => U1 );
has target_info              => ( is => 'ro', required => 1, isa => TargetInfo );
has target_path              => ( is => 'ro', required => 1, isa => TypePath );
has type_index               => ( is => 'ro', required => 1, isa => U2 );
has num_element_value_pairs  => ( is => 'ro', required => 1, isa => U2 );
has element_value_pairs      => ( is => 'ro', required => 1, isa => ArrayRef[ElementValuePair] );
1;
