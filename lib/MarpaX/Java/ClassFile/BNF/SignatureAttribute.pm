use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SignatureAttribute;
use Moo;

# ABSTRACT: Parsing of a Signature_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::SignatureAttribute;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );
my %_signatures = (
                   'class'  => Marpa::R2::Scanless::G->new( { source => \do { ${__PACKAGE__->section_data('signature_class_bnf')}  . ${__PACKAGE__->section_data('signature_common_bnf')} } } ),
                   'method' => Marpa::R2::Scanless::G->new( { source => \do { ${__PACKAGE__->section_data('signature_method_bnf')} . ${__PACKAGE__->section_data('signature_common_bnf')} } } ),
                   'field'  => Marpa::R2::Scanless::G->new( { source => \do { ${__PACKAGE__->section_data('signature_field_bnf')}  . ${__PACKAGE__->section_data('signature_common_bnf')} } } )
                  );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"        => sub { $_[0]->exhausted },
                        'attribute_length$' => sub {
                          my $attribute_length = $_[0]->literalU4('attribute_length');
                          $_[0]->fatalf('attribute_length is %d instead of 2', $attribute_length) unless ($attribute_length == 2)
                        },
                        'signature_index$' => sub {
                          my $signature_index = $_[0]->literalU2('signature_index');
                          my $signature = $_[0]->getAndCheckCpInfo($signature_index, 'ConstantUtf8Info','_value');
                          $_[0]->tracef('Signature is %s', $signature)
                        }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _Signature_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $signature_index) = @_;

  MarpaX::Java::ClassFile::Struct::SignatureAttribute->new(
                                                           attribute_name_index => $_[1],
                                                           attribute_length     => $_[2],
                                                           signature_index      => $_[3]
                                                          )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'attribute_length$' = completed attribute_length
event 'signature_index$' = completed signature_index
Signature_attribute ::=
    attribute_name_index
    attribute_length
    signature_index
  action => _Signature_attribute

attribute_name_index ::= U2 action => u2
attribute_length     ::= U4 action => u4
signature_index      ::= U2 action => u2

__[ signature_common_bnf ]__
Identifier               ::= [.;\[/<>:]+
JavaTypeSignature        ::= ReferenceTypeSignature
                           | BaseType
BaseType                 ::= [BCDFIJSZ]
ReferenceTypeSignature   ::= ClassTypeSignature
                           | TypeVariableSignature
                           | ArrayTypeSignature
ClassTypeSignature       ::= 'L' PackageSpecifierMaybe SimpleClassTypeSignature ClassTypeSignatureSuffixAny ';'
PackageSpecifierUnit     ::= Identifier '/'
PackageSpecifier         ::= PackageSpecifierUnit+
SimpleClassTypeSignature ::= Identifier TypeArgumentsMaybe
TypeArguments            ::= '<' TypeArgument TypeArgumentAny '>'
TypeArgument             ::= WildcardIndicatorMaybe ReferenceTypeSignature
                           | '*'
WildcardIndicator        ::= [+-]
ClassTypeSignatureSuffix ::= '.' SimpleClassTypeSignature
TypeVariableSignature    ::= 'T' Identifier ';'
ArrayTypeSignature       ::= '[' JavaTypeSignature

PackageSpecifierMaybe       ::= PackageSpecifier
PackageSpecifierMaybe       ::=
ClassTypeSignatureSuffixAny ::= ClassTypeSignatureSuffix*
TypeArgumentsMaybe          ::= TypeArguments
TypeArgumentsMaybe          ::=
TypeArgumentAny             ::= TypeArgument*
WildcardIndicatorMaybe      ::= WildcardIndicator
WildcardIndicatorMaybe      ::=

TypeParameters          ::= '<' TypeParameter TypeParameterAny '>'
TypeParameter           ::= Identifier ClassBound InterfaceBoundAny
ClassBound              ::= ':' ReferenceTypeSignatureMaybe
InterfaceBound          ::= ':' ReferenceTypeSignature
SuperclassSignature     ::= ClassTypeSignature
SuperinterfaceSignature ::= ClassTypeSignature

TypeParametersMaybe         ::= TypeParameters
TypeParametersMaybe         ::=
TypeParameterAny            ::= TypeParameter*
ReferenceTypeSignatureMaybe ::= ReferenceTypeSignature
ReferenceTypeSignatureMaybe ::=
SuperinterfaceSignatureAny  ::= SuperinterfaceSignature*
InterfaceBoundAny           ::= InterfaceBound*

Result               ::= JavaTypeSignature
                       | VoidDescriptor
ThrowsSignature      ::= '^' ClassTypeSignature
                       | '^' TypeVariableSignature
VoidDescriptor       ::= 'V'

JavaTypeSignatureAny ::= JavaTypeSignature*
ThrowsSignatureAny   ::= ThrowsSignature*

__[ signature_class_bnf ]__
inaccessible is ok by default
ClassSignature          ::= TypeParametersMaybe SuperclassSignature SuperinterfaceSignatureAny

__[ signature_method_bnf ]__
inaccessible is ok by default
MethodSignature         ::= TypeParametersMaybe '(' JavaTypeSignatureAny ')' Result ThrowsSignatureAny

__[ signature_field_bnf ]__
inaccessible is ok by default
FieldSignature          ::= ReferenceTypeSignature
