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
use MarpaX::Java::ClassFile::BNF::ConstantValueAttribute;
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
            my $attribute_name = $_[0]->getAndCheckCpInfo($_[0]->pauseU2, 'ConstantUtf8Info', '_value');
            $_[0]->tracef('Attribute name is %s', $attribute_name);
            if    ($attribute_name eq 'ConstantValue') { $_[0]->inner('ConstantValueAttribute') }
            elsif ($attribute_name eq 'Signature')     { $_[0]->inner('SignatureAttribute') }
            else {
              $_[0]->warnf('Unmanaged attribute %s', $attribute_name);
              $_[0]->inner('UnmanagedAttribute')
            }
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
