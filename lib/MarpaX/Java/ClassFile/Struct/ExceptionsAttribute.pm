use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ExceptionsAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Attribute name#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           [ sub { 'Exceptions count'                              } => sub { $_[0]->number_of_exceptions } ],
           [ sub { 'Exceptions'                                    } => sub { $_[0]->arrayStringificator([ map {$_[0]->_constant_pool->[$_]} @{$_[0]->exception_index_table}]) } ]
          ];

# ABSTRACT: Exceptions_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4/;
use Types::Standard qw/ArrayRef/;

has _constant_pool         => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index   => ( is => 'ro', required => 1, isa => U2 );
has attribute_length       => ( is => 'ro', required => 1, isa => U4 );
has number_of_exceptions   => ( is => 'ro', required => 1, isa => U2 );
has exception_index_table  => ( is => 'ro', required => 1, isa => ArrayRef[U2] );

1;
