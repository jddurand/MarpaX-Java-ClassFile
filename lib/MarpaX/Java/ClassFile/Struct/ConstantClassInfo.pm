use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantClassInfo;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_Class_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool => ( is => 'rw', required => 1, isa => ArrayRef);
has tag            => ( is => 'ro', required => 1, isa => U1 );
has name_index     => ( is => 'ro', required => 1, isa => U2 );

sub _stringify {
  # my ($self) = @_;

  my $name_index = $_[0]->name_index;
  my $constant = $_[0]->_constant_pool->[$_[0]->name_index];
  "ClassInfo{#$name_index => $constant}"
}

1;
