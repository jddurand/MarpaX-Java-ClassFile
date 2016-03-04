use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile;
use Moo;

# ABSTRACT: Java .class parsing

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Common::BNF qw/bnf/;
use MarpaX::Java::ClassFile::ConstantPoolArray;
use MarpaX::Java::ClassFile::InterfacesArray;
use MarpaX::Java::ClassFile::FieldsArray;
use MarpaX::Java::ClassFile::MethodsArray;
use MarpaX::Java::ClassFile::AttributesArray;
use Scalar::Util qw/blessed/;
use Types::Common::Numeric qw/PositiveOrZeroInt/;
use Types::Standard -all;

my %_ACCESSFLAGS =
  (
   ACC_PUBLIC     => [ 0x0001, 'public'     ],
   ACC_FINAL      => [ 0x0010, 'final'      ],
   ACC_SUPER      => [ 0x0020, 'super'      ],
   ACC_INTERFACE  => [ 0x0200, 'interface'  ],
   ACC_ABSTRACT   => [ 0x0400, 'abstract'   ],
   ACC_SYNTHETIC  => [ 0x1000, 'synthetic'  ],
   ACC_ANNOTATION => [ 0x2000, 'annotation' ],
   ACC_ENUM       => [ 0x4000, 'enum'       ]
);

=head1 DESCRIPTION

MarpaX::Java::ClassFile is doing a parsing of a Java .class file, trying to stand as closed as possible to the binary format, with no language specific interpretation except with the constant pool (see the NOTES section). From the grammar point of view, this mean that there is no interpretation of what is a descriptor, what is a signature, etc.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use MarpaX::Java::ClassFile;

    my $file = '/path/to/some.class';
    #
    # It is the USER'S responsibility to make sure that the following handle
    # is reading in binary format
    #
    open(my $fh, '<', $file) || die "Cannot open $file, $!";
    binmode($fh);
    my $input = do { local $/; <$fh>};
    close($fh) || warn "Cannot close $file, $!";
    my $binaryAst = MarpaX::Java::ClassFile->new(input => $input)->ast;

=head1 CONSTRUCTOR OPTIONS

=head2 input

A scalar hosting a .class file content input. It is the responsibility of the user to make sure that this scalar contain only bytes, please refer to the SYNOPSIS section.

=head1 SUBROUTINES/METHODS

=head2 $class->new(input => Bytes)

Instantiate a new MarpaX::Java::ClassFile object. Takes as parameter a required input.

=head2 $self->ast(--> HashRef)

Returns the AST of the .class file, with the less interpretation as possible. That is, for example, an integer that may be interpreted as a bytes mask is NOT interpreted. It is returned as-is: an integer.

=cut

my $_data = ${ __PACKAGE__->section_data('bnf') };
my $_grammar
    = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );
my %_CALLBACKS = (
    'constantPoolCount$' => \&_constantPoolCountCallback,
    'interfacesCount$'   => \&_interfacesCountCallback,
    'fieldsCount$'       => \&_fieldsCountCallback,
    'methodsCount$'      => \&_methodsCountCallback,
    'attributesCount$'   => \&_attributesCountCallback,
    'minorVersion$'      => \&_minorVersionCallback,
    'majorVersion$'      => \&_majorVersionCallback,
);

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   {$_grammar}
sub callbacks { \%_CALLBACKS }

# ------------
# Our thingies
# ------------

has constantPoolArray => ( is => 'rwp', isa => ArrayRef );
has majorVersion      => ( is => 'rwp', isa => PositiveOrZeroInt);
has minorVersion      => ( is => 'rwp', isa => PositiveOrZeroInt);
has classFiles        => ( is => 'ro',  isa => HashRef[InstanceOf[__PACKAGE__]], default => sub { {} } );

sub BUILD {
  my ($self) = @_;
  $self->debugf('Starting')
}

# ---------------
# Callback callbacks
# ---------------
sub _constantPoolCountCallback {
    my ($self) = @_;
    #
    # Hey, spec says constant pool'S SIZE is $constantPoolCount -1
    # We remember the constantPool for a future use
    #
    $self->_set_constantPoolArray($self->executeInnerGrammar('MarpaX::Java::ClassFile::ConstantPoolArray', size => $self->literalU2 - 1 , classFiles => $self->classFiles, minorVersion => $self->minorVersion, majorVersion => $self->majorVersion))
}

sub _interfacesCountCallback {
    my ($self) = @_;
    $self->executeInnerGrammar('MarpaX::Java::ClassFile::InterfacesArray', size => $self->literalU2 );
}

sub _fieldsCountCallback {
    my ($self) = @_;
    $self->executeInnerGrammar('MarpaX::Java::ClassFile::FieldsArray', size => $self->literalU2 );
}

sub _methodsCountCallback {
    my ($self) = @_;
    $self->executeInnerGrammar('MarpaX::Java::ClassFile::MethodsArray', size => $self->literalU2 );
}

sub _attributesCountCallback {
    my ($self) = @_;
    $self->executeInnerGrammar(
        'MarpaX::Java::ClassFile::AttributesArray', size => $self->literalU2 );
}

sub _minorVersionCallback {
  my ($self) = @_;

  $self->_set_minorVersion($self->literalU2)
}

sub _majorVersionCallback {
  my ($self) = @_;

  $self->_set_majorVersion($self->literalU2)
}


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

sub _ClassFile {
  my ($self,
      $magic,
      $minorVersion,
      $majorVersion,
      $constantPoolCount,
      $constantPoolArray,
      $accessFlags,
      $thisClass,
      $superClass,
      $interfacesCount,
      $interfacesArray,
      $fieldsCount,
      $fieldsArray,
      $methodsCount,
      $methods,
      $attributesCount,
      $attributes) = @_;

  bless [ bless(\$magic,             'magic'),
          bless(\$minorVersion,      'minor_version'),
          bless(\$majorVersion,      'major_version'),
          bless(\$constantPoolCount, 'constant_pool_count'),
          bless( $constantPoolArray, 'constant_pool'),
          bless(\$accessFlags,       'access_flags'),
          bless(\$thisClass,         'this_class'),
          bless(\$superClass,        'super_class'),
          bless(\$interfacesCount,   'interfaces_count'),
          bless( $interfacesArray,   'interfaces'),
          bless(\$fieldsCount,       'fields_count'),
          bless( $fieldsArray,       'fields'),
          bless(\$methodsCount,      'methods_count'),
          bless( $methods,           'methods'),
          bless(\$attributesCount,   'attributes_count'),
          bless( $attributes,        'attributes')
        ], 'ClassFile'
}

with qw/MarpaX::Java::ClassFile::Common/;

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'minorVersion$'      = completed minorVersion
event 'majorVersion$'      = completed majorVersion
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
