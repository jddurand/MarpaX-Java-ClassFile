use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantPoolArray;
use Moo;

# ABSTRACT: Parsing an array of constant pool

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use Types::Standard -all;

use constant {
  CONSTANT_Utf8               =>  1,
  CONSTANT_Integer            =>  3,
  CONSTANT_Float              =>  4,
  CONSTANT_Long               =>  5,
  CONSTANT_Double             =>  6,
  CONSTANT_Class              =>  7,
  CONSTANT_String             =>  8,
  CONSTANT_Fieldref           =>  9,
  CONSTANT_Methodref          => 10,
  CONSTANT_InterfaceMethodref => 11,
  CONSTANT_NameAndType        => 12,
  CONSTANT_MethodHandle       => 15,
  CONSTANT_MethodType         => 16,
  CONSTANT_InvokeDynamic      => 18
};

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted" => sub { $_[0]->exhausted },
          'cpInfo$'     => sub { $_[0]->inc_nbDone },
          '!tag' => sub {
            my $tag = $_[0]->literalU1;

            if    ($tag == CONSTANT_Utf8)               { $_[0]->inner('ConstantUtf8Info') }
            elsif ($tag == CONSTANT_Integer)            { $_[0]->inner('ConstantIntegerInfo') }
            elsif ($tag == CONSTANT_Float)              { $_[0]->inner('ConstantFloatInfo') }
            elsif ($tag == CONSTANT_Long)               { $_[0]->inner('ConstantLongInfo') }
            elsif ($tag == CONSTANT_Double)             { $_[0]->inner('ConstantDoubleInfo') }
            elsif ($tag == CONSTANT_Class)              { $_[0]->inner('ConstantClassInfo') }
            elsif ($tag == CONSTANT_String)             { $_[0]->inner('ConstantStringInfo') }
            elsif ($tag == CONSTANT_Fieldref)           { $_[0]->inner('ConstantFieldrefInfo') }
            elsif ($tag == CONSTANT_Methodref)          { $_[0]->inner('ConstantMethodrefInfo') }
            elsif ($tag == CONSTANT_InterfaceMethodref) { $_[0]->inner('ConstantInterfaceMethodrefInfo') }
            elsif ($tag == CONSTANT_NameAndType)        { $_[0]->inner('ConstantNameAndTypeInfo') }
            elsif ($tag == CONSTANT_MethodHandle)       { $_[0]->inner('ConstantMethodHandleInfo') }
            elsif ($tag == CONSTANT_MethodType)         { $_[0]->inner('ConstantMethodTypeInfo') }
            elsif ($tag == CONSTANT_InvokeDynamic)      { $_[0]->inner('ConstantInvokeDynamicInfo') }
            else                                        { $_[0]->inner('ConstantUnmanagedInfo') }
          }
         }
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event '!tag'    = nulled tag
event 'cpInfo$' = completed cpInfo

cpInfoArray ::= cpInfo*
cpInfo ::= (u1) (tag)                          # tag is reinjected in managed
           managed        action => ::first    # Every managed is returning an object
tag ::=
