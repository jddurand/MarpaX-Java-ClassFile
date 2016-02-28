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
use Types::Standard -all;

=head1 DESCRIPTION

MarpaX::Java::ClassFile is doing a parsing of a Java .class file, trying to stand as closed as possible to the binary format, with no Java specific interpretation except with the constant pool (see the NOTES section). From the grammar point of view, this mean that there is no interpretation of what is a descriptor, what is a signature, etc.

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
    'ClassFile$'         => \&_ClassFile
);

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   {$_grammar}
sub callbacks { \%_CALLBACKS }

# ------------
# Our thingies
# ------------
sub BUILD {
  my ($self) = @_;
  $self->debugf('Starting')
}

# ---------------
# Callback callbacks
# ---------------
sub _constantPoolCountCallback {
    my ( $self, $r ) = @_;
    #
    # Hey, spec says constant pool'S SIZE is $constantPoolCount -1
    #
    $self->executeInnerGrammar( $r,
        'MarpaX::Java::ClassFile::ConstantPoolArray',
        'MANAGED', size => $self->literalU2($r) - 1 );
}

sub _interfacesCountCallback {
    my ( $self, $r ) = @_;
    $self->executeInnerGrammar( $r,
        'MarpaX::Java::ClassFile::InterfacesArray',
        'MANAGED', size => $self->literalU2($r) );
}

sub _fieldsCountCallback {
    my ( $self, $r ) = @_;
    $self->executeInnerGrammar( $r, 'MarpaX::Java::ClassFile::FieldsArray',
        'MANAGED', size => $self->literalU2($r) );
}

sub _methodsCountCallback {
    my ( $self, $r ) = @_;
    $self->executeInnerGrammar( $r, 'MarpaX::Java::ClassFile::MethodsArray',
        'MANAGED', size => $self->literalU2($r) );
}

sub _attributesCountCallback {
    my ( $self, $r ) = @_;
    $self->executeInnerGrammar( $r,
        'MarpaX::Java::ClassFile::AttributesArray',
        'MANAGED', size => $self->literalU2($r) );
}

=head1 NOTES

Constant pool is a special case because the grammar imposes that every entry in it has a "type". Therefore the following entries in the constant pool at explicitely interpreted:

=over

=item Integer

A per's scalar is returned.

=item Float

A Math::BigFloat object instance is returned.

=item Long

A per's scalar is returned.

=item Double

A Math::BigFloat object instance is returned.

=item Utf8

A per's scalar is returned.

=back

In addition, because a constant pool can skip its indices, and indice number is also returned for every entry.

=cut

# --------------------
# Our grammar actions
# --------------------
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
event 'constantPoolCount$' = completed constantPoolCount
event 'interfacesCount$'   = completed interfacesCount
event 'fieldsCount$'       = completed fieldsCount
event 'methodsCount$'      = completed methodsCount
event 'attributesCount$'   = completed attributesCount
event 'ClassFile$'         = completed ClassFile
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
