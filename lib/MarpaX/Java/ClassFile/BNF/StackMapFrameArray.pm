use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::StackMapFrameArray;
use Moo;

# ABSTRACT: Parsing an array of stack_map_frame

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::BNF::SameFrame;
use MarpaX::Java::ClassFile::BNF::SameLocals1StackItemFrame;
use MarpaX::Java::ClassFile::BNF::SameLocals1StackItemFrameExtended;
use MarpaX::Java::ClassFile::BNF::ChopFrame;
use MarpaX::Java::ClassFile::BNF::SameFrameExtended;
use MarpaX::Java::ClassFile::BNF::AppendFrame;
use MarpaX::Java::ClassFile::BNF::FullFrame;
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
           "'exhausted"      => sub { $_[0]->exhausted },
          'stack_map_frame$' => sub { $_[0]->inc_nbDone },
          '^U1' => sub {
            my $tag = $_[0]->pauseU1;
            if    ($tag >=  0  && $tag <=  63) { $_[0]->inner('SameFrame') }
            elsif ($tag >= 64  && $tag <= 127) { $_[0]->inner('SameLocals1StackItemFrame') }
            elsif (               $tag == 247) { $_[0]->inner('SameLocals1StackItemFrameExtended') }
            elsif ($tag >= 248 && $tag <= 250) { $_[0]->inner('ChopFrame') }
            elsif (               $tag == 251) { $_[0]->inner('SameFrameExtended') }
            elsif ($tag >= 252 && $tag <= 254) { $_[0]->inner('AppendFrame') }
            elsif (               $tag == 255) { $_[0]->inner('FullFrame') }
            else                               { $_[0]->fatalf('Unmanaged frame type %s', $tag) }
          }
         }
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
:lexeme ~ <U1> pause => before event => '^U1'
event 'stack_map_frame$' = completed stack_map_frame

stackMapFrameArray ::= stack_map_frame*
stack_map_frame    ::= U1
                     | MANAGED   action => ::first
