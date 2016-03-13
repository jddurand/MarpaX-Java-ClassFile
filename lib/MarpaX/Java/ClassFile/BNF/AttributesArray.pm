use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::AttributesArray;
use Moo;

# ABSTRACT: Parsing an array of attribute

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/bnf/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::BNF::ConstantValueAttribute;
require MarpaX::Java::ClassFile::BNF::CodeAttribute;
require MarpaX::Java::ClassFile::BNF::StackMapTableAttribute;
require MarpaX::Java::ClassFile::BNF::ExceptionsAttribute;
require MarpaX::Java::ClassFile::BNF::InnerClassesAttribute;
require MarpaX::Java::ClassFile::BNF::EnclosingMethodAttribute;
require MarpaX::Java::ClassFile::BNF::SyntheticAttribute;
require MarpaX::Java::ClassFile::BNF::SignatureAttribute;
require MarpaX::Java::ClassFile::BNF::SourceFileAttribute;
require MarpaX::Java::ClassFile::BNF::SourceDebugExtensionAttribute;
require MarpaX::Java::ClassFile::BNF::LineNumberTableAttribute;
require MarpaX::Java::ClassFile::BNF::LocalVariableTableAttribute;
require MarpaX::Java::ClassFile::BNF::LocalVariableTypeTableAttribute;
require MarpaX::Java::ClassFile::BNF::DeprecatedAttribute;
require MarpaX::Java::ClassFile::BNF::RuntimeVisibleAnnotationsAttribute;
require MarpaX::Java::ClassFile::BNF::UnmanagedAttribute;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted" => sub { $_[0]->exhausted },
          'attribute_info$' => sub { $_[0]->inc_nbDone },
          '^U2' => sub {
            my $attribute_name = $_[0]->getAndCheckCpInfo($_[0]->pauseU2, 'ConstantUtf8Info', '_value');
            if    ($attribute_name eq 'ConstantValue')             { $_[0]->inner('ConstantValueAttribute') }
            elsif ($attribute_name eq 'Code')                      { $_[0]->inner('CodeAttribute') }
            elsif ($attribute_name eq 'StackMapTable')             { $_[0]->inner('StackMapTableAttribute') }
            elsif ($attribute_name eq 'Exceptions')                { $_[0]->inner('ExceptionsAttribute') }
            elsif ($attribute_name eq 'InnerClasses')              { $_[0]->inner('InnerClassesAttribute') }
            elsif ($attribute_name eq 'EnclosingMethod')           { $_[0]->inner('EnclosingMethodAttribute') }
            elsif ($attribute_name eq 'Synthetic')                 { $_[0]->inner('SyntheticAttribute') }
            elsif ($attribute_name eq 'Signature')                 { $_[0]->inner('SignatureAttribute') }
            elsif ($attribute_name eq 'SourceFile')                { $_[0]->inner('SourceFileAttribute') }
            elsif ($attribute_name eq 'SourceDebugExtension')      { $_[0]->inner('SourceDebugExtensionAttribute') }
            elsif ($attribute_name eq 'LineNumberTable')           { $_[0]->inner('LineNumberTableAttribute') }
            elsif ($attribute_name eq 'LocalVariableTable')        { $_[0]->inner('LocalVariableTableAttribute') }
            elsif ($attribute_name eq 'LocalVariableTypeTable')    { $_[0]->inner('LocalVariableTypeTableAttribute') }
            elsif ($attribute_name eq 'Deprecated')                { $_[0]->inner('DeprecatedAttribute') }
            elsif ($attribute_name eq 'RuntimeVisibleAnnotations') { $_[0]->inner('RuntimeVisibleAnnotationsAttribute') }
            else {
              $_[0]->infof('Unmanaged attribute %s', $attribute_name);
              $_[0]->inner('UnmanagedAttribute')
            }
          }
         }
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
:lexeme ~ <U2> pause => before event => '^U2'
event 'attribute_info$' = completed attribute_info

attributesArray ::= attribute_info*
attribute_info ::= U2
                 | MANAGED   action => ::first
