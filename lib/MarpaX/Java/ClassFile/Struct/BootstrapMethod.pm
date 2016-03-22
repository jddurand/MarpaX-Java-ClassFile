use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::BootstrapMethod;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { 'Bootstrap method#' . $_[0]->bootstrap_method_ref } => sub { $_[0]->_constant_pool->[$_[0]->bootstrap_method_ref] } ],
           [ sub { 'Bootstrap arguments count'                       } => sub { $_[0]->num_bootstrap_arguments } ],
           [ sub { 'Bootstrap arguments'                             } => sub { $_[0]->arrayStringificator($_[0]->bootstrap_arguments) } ]
          ];

# ABSTRACT: bootstrap method

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool          => ( is => 'rw', required => 1, isa => ArrayRef);
has bootstrap_method_ref    => ( is => 'ro', required => 1, isa => U2 );
has num_bootstrap_arguments => ( is => 'ro', required => 1, isa => U2 );
has bootstrap_arguments     => ( is => 'ro', required => 1, isa => ArrayRef[U2] );

1;
