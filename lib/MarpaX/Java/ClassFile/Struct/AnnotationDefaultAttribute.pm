use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::AnnotationDefaultAttribute;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { '#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           [ sub { 'default value' } => sub { $_[0]->default_value } ]
          ];

# ABSTRACT: AnnotationDefault_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 ElementValue/;

has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has default_value         => ( is => 'ro', required => 1, isa => ElementValue );

1;
