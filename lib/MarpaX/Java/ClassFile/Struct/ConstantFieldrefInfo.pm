use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantFieldrefInfo;
use MarpaX::Java::ClassFile::Struct::_Base;
use overload '""' => \&_stringify;

# ABSTRACT: CONSTANT_Fieldref_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool      => ( is => 'rw', required => 1, isa => ArrayRef);
has tag                 => ( is => 'ro', required => 1, isa => U1 );
has class_index         => ( is => 'ro', required => 1, isa => U2 );
has name_and_type_index => ( is => 'ro', required => 1, isa => U2 );

sub _stringify {
  # my ($self) = @_;

  my $class_index         = $_[0]->class_index;
  my $name_and_type_index = $_[0]->name_and_type_index;

  my $constant_class         = $_[0]->_constant_pool->[$_[0]->class_index];
  my $constant_name_and_type = $_[0]->_constant_pool->[$_[0]->name_and_type_index];

  "Fieldref{class_index:#$class_index => $constant_class, name_and_type_index:#$name_and_type_index => $constant_name_and_type}"
}

1;
