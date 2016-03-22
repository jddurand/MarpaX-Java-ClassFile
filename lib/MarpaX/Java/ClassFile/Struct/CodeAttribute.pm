use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::CodeAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Attribute name#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           [ sub { 'Max stack'                                     } => sub { $_[0]->max_stack  } ],
           [ sub { 'Max locals'                                    } => sub { $_[0]->max_locals } ],
           [ sub { 'Code'                                          } => sub { $_[0]->arrayStringificator($_[0]->code) } ],
           [ sub { 'Exception table count'                         } => sub { $_[0]->exception_table_length } ],
           [ sub { 'Exception table'                               } => sub { $_[0]->arrayStringificator($_[0]->exception_table) } ],
           [ sub { 'Attributes count'                              } => sub { $_[0]->attributes_count } ],
           [ sub { 'Attributes'                                    } => sub { $_[0]->arrayStringificator($_[0]->attributes) } ],
          ]
  ;

# ABSTRACT: Code_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 OpCode ExceptionTable AttributeInfo/;
use Types::Standard qw/ArrayRef/;

has _constant_pool           => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index    => ( is => 'ro', required => 1, isa => U2 );
has attribute_length        => ( is => 'ro', required => 1, isa => U4 );
has max_stack               => ( is => 'ro', required => 1, isa => U2 );
has max_locals              => ( is => 'ro', required => 1, isa => U2 );
has code_length             => ( is => 'ro', required => 1, isa => U4 );
has code                    => ( is => 'ro', required => 1, isa => ArrayRef[OpCode] );
has exception_table_length  => ( is => 'ro', required => 1, isa => U2 );
has exception_table         => ( is => 'ro', required => 1, isa => ArrayRef[ExceptionTable] );
has attributes_count        => ( is => 'ro', required => 1, isa => U2 );
has attributes              => ( is => 'ro', required => 1, isa => ArrayRef[AttributeInfo] );

1;
