use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ClassFile;
use Moo;

# ABSTRACT: Parsing of a ClassFile

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::BNF::ConstantPoolArray;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::_Types -all;
use MarpaX::Java::ClassFile::Struct::ClassFile;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          #
          # For constant pool indexes start at 1:
          # - The final action on Constant pool will insert a fake undef entry at position 0
          #
          '!constant_pool_count' => sub {
            $_[0]->constant_pool
              (
               $_[0]->inner('ConstantPoolArray', size => $_[0]->literalU2 - 1)
              )
            },
          '!interfaces_count'    => sub {
            $_[0]->inner('InterfacesArray', size => $_[0]->literalU2)
          },
          '!fields_count'        => sub { $_[0]->inner('FieldsArray',     size => $_[0]->literalU2) },
          '!methods_count'       => sub { $_[0]->inner('MethodsArray',    size => $_[0]->literalU2) },
          '!attributes_count'    => sub { $_[0]->inner('AttributesArray', size => $_[0]->literalU2) }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _ClassFile {
  my ($self,
      $magic,
      $minor_version,
      $major_version,
      $constant_pool_count,
      $constant_pool,
      $access_flags,
      $this_class,
      $super_class,
      $interfaces_count,
      $interfaces,
      $fields_count,
      $fields,
      $methods_count,
      $methods,
      $attributes_count,
      $attributes) = @_;

  MarpaX::Java::ClassFile::Struct::ClassFile->new(
                                                  magic               => $magic,
                                                  minor_version       => $minor_version,
                                                  major_version       => $major_version,
                                                  constant_pool_count => $constant_pool_count,
                                                  constant_pool       => $constant_pool,
                                                  access_flags        => $access_flags,
                                                  this_class          => $this_class,
                                                  super_class         => $super_class,
                                                  interfaces_count    => $interfaces_count,
                                                  interfaces          => $interfaces,
                                                  fields_count        => $fields_count,
                                                  fields              => $fields,
                                                  methods_count       => $methods_count,
                                                  methods             => $methods,
                                                  attributes_count    => $attributes_count,
                                                  attributes          => $attributes
                                                 )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

#
# We want to take control over constant_pool in this class (and only here btw)
#
has '+constant_pool' => ( is => 'rw', isa => ArrayRef[CpInfo], default => sub { [] });

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event '!constant_pool_count' = nulled constant_pool_count
event '!interfaces_count'    = nulled interfaces_count
event '!fields_count'        = nulled fields_count
event '!methods_count'       = nulled methods_count
event '!attributes_count'    = nulled attributes_count
ClassFile ::=
             u4      # magic
             u2      # minor_version
             u2      # major_version
             u2      (constant_pool_count)
             managed # constant_pool
             u2      # access_flags
             u2      # this_class
             u2      # super_class
             u2      (interfaces_count)
             managed # interfaces
             u2      (fields_count)
             managed # fields
             u2      (methods_count)
             managed # methods
             u2      (attributes_count)
             managed # attributes
  action => _ClassFile

constant_pool_count  ::=
interfaces_count     ::=
fields_count         ::=
methods_count        ::=
attributes_count     ::=
