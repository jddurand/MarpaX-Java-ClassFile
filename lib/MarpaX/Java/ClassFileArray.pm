use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFileArray;
use Moo;

# ABSTRACT: Java .class parsing

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use MarpaX::Java::ClassFile;
use MarpaX::Java::ClassFile::ConstantPoolArray;
use MarpaX::Java::ClassFile::InterfacesArray;
use MarpaX::Java::ClassFile::FieldsArray;
use MarpaX::Java::ClassFile::MethodsArray;
use MarpaX::Java::ClassFile::AttributesArray;
use Scalar::Util qw/blessed/;
use Types::Common::Numeric qw/PositiveOrZeroInt/;
use Types::Standard -all;

has constantPoolArray => ( is => 'rwp', isa => ArrayRef[InstanceOf['MarpaX::Java::ClassFile::ConstantPool']|Undef]);

=head1 DESCRIPTION

MarpaX::Java::ClassFile is doing a parsing of a Java .class file, trying to stand as closed as possible to the binary format, with no language specific interpretation except with the constant pool (see the NOTES section). From the grammar point of view, this mean that there is no interpretation of what is a descriptor, what is a signature, etc.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use MarpaX::Java::ClassFile;

    my $classFile = MarpaX::Java::ClassFile->new('/path/to/some.class');

=head1 CONSTRUCTOR OPTIONS

=head2 inputRef

A scalar hosting a reference to a .class file content. It is the responsibility of the user to make sure that this scalar contain only bytes, please refer to the SYNOPSIS section. Alternatively, specifying a single option will be considered as path to the .class file, and the constructor will do the read in binary mode automatically.

=head1 SUBROUTINES/METHODS

=cut

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );
my %_CALLBACKS = (
                  #
                  # For constant pool indexes start at 1, c.f. constraints on *_index.
                  # The final action on Constant pool will insert a fake undef entry at position 0
                  #
                  'constantPoolCount$' => sub {
                    $_[0]->_set_constantPoolArray($_[0]->executeInnerGrammar(
                                                                             'MarpaX::Java::ClassFile::ConstantPoolArray',
                                                                             'array',
                                                                             classFile => $_[0],
                                                                             size => $_[0]->literalU2 - 1
                                                                            ))
                  },
                  'interfacesCount$'   => sub {
                    $_[0]->executeInnerGrammar(
                                               'MarpaX::Java::ClassFile::InterfacesArray',
                                               'array',
                                               classFile => $_[0],
                                               size => $_[0]->literalU2
                                              )
                  },
                  'fieldsCount$'       => sub {
                    $_[0]->executeInnerGrammar(
                                               'MarpaX::Java::ClassFile::FieldsArray',
                                               'array',
                                               classFile => $_[0],
                                               size => $_[0]->literalU2
                                      )
                  },
                  'methodsCount$'      => sub {
                    $_[0]->executeInnerGrammar(
                                               'MarpaX::Java::ClassFile::MethodsArray',
                                               'array',
                                               classFile => $_[0],
                                               size => $_[0]->literalU2
                                       )
                  },
                  'attributesCount$'   => sub {
                    $_[0]->executeInnerGrammar(
                                               'MarpaX::Java::ClassFile::AttributesArray',
                                               'array',
                                               classFile => $_[0],
                                               size => $_[0]->literalU2
                                              )
                  }
                 );

# ---------------------------
# Constructor argument helper
# ---------------------------
sub BUILDARGS {
  my ($class, @args) = @_;

  if (@args % 2 == 1) {
    open(my $fh, '<', $args[0]) || croak "Cannot open $args[0], $!";
    binmode($fh);
    @args = ( inputRef => \do { local $/; <$fh>} );
    close($fh) || warn "Cannot close $args[0], $!";
  }

  return { @args }
}

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { \%_CALLBACKS }

=head1 NOTES

Constant pool is a special case, it is sort of "base information" for everything afterwards. Therefore the following entries in the constant pool are explicitely converted to a perl scalar when the associated string representation is unambiguous, or to a Math::BigFloat in case of uncertainty, i.e.:

=over

=item Integer

A per's scalar.

=item Float

A Math::BigFloat object instance.

=item Long

A per's scalar.

=item Double

A Math::BigFloat object instance.

=item Utf8

A per's scalar.

=back

This will be visible under the key "computed_value" into the hash containing the parse tree value of the associated pool entry.

=cut

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

  MarpaX::Java::ClassFile->new(
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
                               attributes          => $attributes)
}

with qw/MarpaX::Java::ClassFile::Common/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'constantPoolCount$' = completed constantPoolCount
event 'interfacesCount$'   = completed interfacesCount
event 'fieldsCount$'       = completed fieldsCount
event 'methodsCount$'      = completed methodsCount
event 'attributesCount$'   = completed attributesCount
ClassFile ::=
             magic
             minorVersion
             majorVersion
             constantPoolCount
             constantPoolArray
             accessFlags
             thisClass
             superClass
             interfacesCount
             interfacesArray
             fieldsCount
             fieldsArray
             methodsCount
             methods
             attributesCount
             attributes             action => _ClassFile
magic              ::= u4
minorVersion       ::= u2
majorVersion       ::= u2
constantPoolCount  ::= u2
constantPoolArray  ::= managed
accessFlags        ::= u2
thisClass          ::= u2
superClass         ::= u2
interfacesCount    ::= u2
interfacesArray    ::= managed
fieldsCount        ::= u2
fieldsArray        ::= managed
methodsCount       ::= u2
methods            ::= managed
attributesCount    ::= u2
attributes         ::= managed
