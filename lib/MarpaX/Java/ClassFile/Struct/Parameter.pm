use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Parameter;
use MarpaX::Java::ClassFile::Util::AccessFlagsStringification qw/accessFlagsStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           #
           # name_index can be zero
           #
           [ sub { 'Name#' . $_[0]->name_index } => sub { ($_[0]->name_index > 0) ? $_[0]->_constant_pool->[$_[0]->name_index] : '' } ],
           [ sub { 'Access flags'              } => sub { $_[0]->accessFlagsStringificator($_[0]->access_flags) } ]
          ];

# ABSTRACT: parameter

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool => ( is => 'rw', required => 1, isa => ArrayRef);
has name_index     => ( is => 'ro', required => 1, isa => U2 );
has access_flags   => ( is => 'ro', required => 1, isa => U2 );

1;
