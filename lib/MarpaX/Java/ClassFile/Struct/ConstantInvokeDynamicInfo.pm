use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantInvokeDynamicInfo;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Bootstrap method attribute#' . $_[0]->bootstrap_method_attr_index } => sub { $_[0]->_constant_pool->[$_[0]->bootstrap_method_attr_index] } ],
           [ sub { 'Name and type#' . $_[0]->name_and_type_index                      } => sub { $_[0]->_constant_pool->[$_[0]->name_and_type_index] } ]
          ];

# ABSTRACT: CONSTANT_InvokeDynamic_info entry

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool              => ( is => 'rw', required => 1, isa => ArrayRef);
has tag                         => ( is => 'ro', required => 1, isa => U1 );
has bootstrap_method_attr_index => ( is => 'ro', required => 1, isa => U2 );
has name_and_type_index         => ( is => 'ro', required => 1, isa => U2 );

1;
