use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ExceptionTable;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'start_pc  ' }            => sub { $_[0]->start_pc } ],
           [ sub { 'end_pc    ' }            => sub { $_[0]->end_pc } ],
           [ sub { 'handler_pc' }            => sub { $_[0]->handler_pc } ],
           [ sub { '#' . $_[0]->catch_type } => sub { ($_[0]->catch_type > 0) ? $_[0]->_constant_pool->[$_[0]->catch_type] : '' } ]
          ];

# ABSTRACT: exception_table

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool => ( is => 'rw', required => 1, isa => ArrayRef);
has start_pc       => ( is => 'ro', required => 1, isa => U2 );
has end_pc         => ( is => 'ro', required => 1, isa => U2 );
has handler_pc     => ( is => 'ro', required => 1, isa => U2 );
has catch_type     => ( is => 'ro', required => 1, isa => U2 );

1;
