use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantIntegerInfo;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_Integer_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;
use Types::Encodings qw/Bytes/;
use Types::Standard qw/Int/;

has _perlvalue   => ( is => 'ro', required => 1, isa => Int );
has tag          => ( is => 'ro', required => 1, isa => U1 );
has bytes        => ( is => 'ro', required => 1, isa => Bytes );

sub _stringify {
  # my ($self) = @_;

  my $_perlvalue = $_[0]->_perlvalue;

  "Integer=$_perlvalue"
}

1;
