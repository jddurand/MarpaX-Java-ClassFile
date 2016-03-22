use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariableType;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { '#' . $_[0]->name_index }      => sub { $_[0]->_constant_pool->[$_[0]->name_index] } ],
           [ sub { '#' . $_[0]->signature_index } => sub { $_[0]->_constant_pool->[$_[0]->signature_index] } ],
           [ sub { 'Start pc'}                    => sub { $_[0]->start_pc } ],
           [ sub { 'Length'}                      => sub { $_[0]->length } ],
           [ sub { 'Index'}                       => sub { $_[0]->index } ]
          ];

# ABSTRACT: local variable type

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has start_pc         => ( is => 'ro', required => 1, isa => U2 );
has length           => ( is => 'ro', required => 1, isa => U2 );
has name_index       => ( is => 'ro', required => 1, isa => U2 );
has signature_index  => ( is => 'ro', required => 1, isa => U2 );
has index            => ( is => 'ro', required => 1, isa => U2 );

1;
