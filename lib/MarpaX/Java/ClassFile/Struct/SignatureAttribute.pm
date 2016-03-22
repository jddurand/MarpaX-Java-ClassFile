use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SignatureAttribute;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Attribute name#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           [ sub { 'Signature#' . $_[0]->signature_index           } => sub { $_[0]->_constant_pool->[$_[0]->signature_index] } ]
          ];

# ABSTRACT: Signature_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;

has attribute_name_index => ( is => 'ro', required => 1, isa => U2 );
has attribute_length     => ( is => 'ro', required => 1, isa => U4 );
has signature_index      => ( is => 'ro', required => 1, isa => U2 );

1;
