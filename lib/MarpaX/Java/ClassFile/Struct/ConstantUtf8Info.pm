use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantUtf8Info;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_Utf8_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Encodings qw/Bytes/;
use Types::Standard qw/Str Undef/;

has _perlvalue   => ( is => 'ro', required => 1, isa => Str|Undef);
has tag          => ( is => 'ro', required => 1, isa => U1 );
has length       => ( is => 'ro', required => 1, isa => U2 );
has bytes        => ( is => 'ro', required => 1, isa => Bytes|Undef );

sub _stringify {
  # my ($self) = @_;

  my $_perlvalue = $_[0]->_perlvalue // '';

  "Utf8=$_perlvalue"
}

1;
