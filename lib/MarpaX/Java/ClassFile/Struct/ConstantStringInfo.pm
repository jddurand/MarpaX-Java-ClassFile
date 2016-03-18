use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantStringInfo;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_String_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2 ConstantPoolArray/;
use Types::Standard qw/ArrayRef/;

has _constant_pool => ( is => 'rw', required => 1, isa => ConstantPoolArray);
has tag            => ( is => 'ro', required => 1, isa => U1 );
has string_index   => ( is => 'ro', required => 1, isa => U2 );

sub _stringify {
  # my ($self) = @_;

  my $string_index = $_[0]->string_index;
  my $constant     = $_[0]->_constant_pool->get($_[0]->string_index);

  "StringInfo{#$string_index => $constant}"
}

1;
