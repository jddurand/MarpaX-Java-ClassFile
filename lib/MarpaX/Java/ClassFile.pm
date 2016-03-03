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

# --------------------
# Our grammar actions
# --------------------
sub _accessFlags {
  my ($self, $u2) = @_;

  my @accessFlags = ();

  my $allbits = 0;
  my %hasFlag = ();
  foreach (keys %_ACCESSFLAGS) {
    my ($mask, $value) = @{$_ACCESSFLAGS{$_}};
    $hasFlag{$_} = (($u2 & $mask) == $mask) ? 1 : 0;
    push(@accessFlags, $value) if ($hasFlag{$_});
    $allbits |= $mask;
  }
  #
  # Check what the spec says about access flags contraints
  #
  if ($hasFlag{ACC_INTERFACE}) {
    #
    # If the ACC_INTERFACE flag is set, the ACC_ABSTRACT flag must also be set,
    # and the ACC_FINAL, ACC_SUPER, and ACC_ENUM flags set must not be set.
    #
    $self->errorf('ACC_ABSTRACT flag must be set') unless ($hasFlag{ACC_ABSTRACT});
    $self->errorf('ACC_FINAL flag must not be set')    if ($hasFlag{ACC_FINAL});
    $self->errorf('ACC_SUPER flag must not be set')    if ($hasFlag{ACC_SUPER});
    $self->errorf('ACC_ENUM flag must not be set')     if ($hasFlag{ACC_ENUM});
  } else {
    #
    # If the ACC_INTERFACE flag is not set, any of the other flags in (...) may be set
    # except ACC_ANNOTATION.
    #
    $self->errorf('ACC_ANNOTATION flag must not be set') if ($hasFlag{ACC_ANNOTATION});
    #
    # However, such a class file must not have both its ACC_FINAL and ACC_ABSTRACT flags set
    #
    $self->errorf('ACC_FINAL and ACC_ABSTRACT flags must not be both set') if ($hasFlag{ACC_FINAL} && $hasFlag{ACC_ABSTRACT});
  }
  #
  # If the ACC_ANNOTATION flag is set, the ACC_INTERFACE flag must also be set.
  #
  $self->errorf('ACC_INTERFACE flag must be set') if ($hasFlag{ACC_ANNOTATION} && ! $hasFlag{ACC_INTERFACE});

  bless({ u2 => $u2, computed_value =>\@accessFlags }, 'access_flags')
}

sub _thisClass {
  my ($self, $u2) = @_;

  my $thisClass = undef;
  #
  # The value of the this_class item must be a valid index into the constant_pool table.
  #
  my $constantPoolArray = $self->constantPoolArray;
  if ($u2 > scalar(@{$constantPoolArray})) {
    $self->warnf('this_class item must be a valid index into the constant_pool table, got %d > %d', $u2, scalar(@{$constantPoolArray}))
  } else {
    my $constantPoolItem = $constantPoolArray->[$u2 - 1];
    #
    # The constant_pool entry at that index must be a CONSTANT_Class_info structure (...)
    # representing the class or interface defined by this class file.
    #
    my $blessed = blessed($constantPoolItem) // '';
    if ($blessed ne 'CONSTANT_Class_info') {
      $self->warnf('The constant_pool entry at index %d must be a CONSTANT_Class_info structure, got %s', $u2, $blessed)
    } else {
      my $name_index = $constantPoolItem->{name_index};
      $thisClass = $constantPoolArray->[$name_index - 1]->{computed_value};
    }
  }

  $thisClass
}

sub _ClassFile {
    my $i = 0;
    bless(
        {   magic             => $_[ ++$i ],
            minorVersion      => $_[ ++$i ],
            majorVersion      => $_[ ++$i ],
            constantPoolCount => $_[ ++$i ],
            constantPoolArray => $_[ ++$i ],
            accessFlags       => $_[ ++$i ],
            thisClass         => $_[ ++$i ],
            superClass        => $_[ ++$i ],
            interfacesCount   => $_[ ++$i ],
            interfacesArray   => $_[ ++$i ],
            fieldsCount       => $_[ ++$i ],
            fieldsArray       => $_[ ++$i ],
            methodsCount      => $_[ ++$i ],
            methods           => $_[ ++$i ],
            attributesCount   => $_[ ++$i ],
            attributes        => $_[ ++$i ]
        },
        'ClassFile'
    );
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
accessFlags        ::= u2           action => _accessFlags
thisClass          ::= u2           action => _thisClass
superClass         ::= u2
interfacesCount    ::= u2
interfacesArray    ::= managed
fieldsCount        ::= u2
fieldsArray        ::= managed
methodsCount       ::= u2
methods            ::= managed
attributesCount    ::= u2
attributes         ::= managed
