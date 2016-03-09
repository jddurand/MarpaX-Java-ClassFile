use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::AttributesArray;
use Moo;

# ABSTRACT: Parsing an array of attribute

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::BNF::SignatureAttribute;
use MarpaX::Java::ClassFile::BNF::UnmanagedAttribute;
use Scalar::Util qw/blessed/;
use Types::Standard -all;

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
            my $attribute_name_index = $_[0]->pauseU2;
            #
            # $attribute_name_index must be a CONSTANT_Utf8_info object in the constant pool
            #
            my $cpInfo = $_[0]->constant_pool->[$attribute_name_index];
            my $blessed = blessed($cpInfo) // '';
            $_[0]->fatalf('Invalid attribute_name_index %d', $attribute_name_index) unless ($blessed eq 'MarpaX::Java::ClassFile::Struct::ConstantUtf8Info');
            my $attribute_name = $cpInfo->_value;
            $_[0]->fatalf('String is undef in constant pool No %d', $attribute_name_index) unless (defined($attribute_name));

            if ($attribute_name eq 'Signature') { $_[0]->inner('SignatureAttribute') }
            else { $_[0]->inner('UnmanagedAttribute') }
          }
         }
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
:lexeme ~ <U2> pause => before event => '^U2'
event 'attribute_info$' = completed attribute_info

attributesArray ::= attribute_info*
attribute_info ::= U2
                 | MANAGED   action => ::first
