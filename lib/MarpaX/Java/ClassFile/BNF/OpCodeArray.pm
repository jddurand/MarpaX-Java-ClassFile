use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::OpCodeArray;
use Moo;

# ABSTRACT: Parsing an array of opcodes

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::OpCode;
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
          'opcode$'     => sub { $_[0]->inc_nbDone },
         }
}

sub aaload  { [ 'aaload' ] }
sub aastore { [ 'aastore' ] }

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'opcode$' = completed opcode

opcodeArray ::= opcode* action => [values]

opcode ::= aaload
         | aastore
         | aconst_null
         | aload index
         | aload_0
         | aload_1
         | aload_2
         | aload_3
         | anewarray indexbyte1 indexbyte2
         | areturn
         | arraylength
         | astore index
         | astore_0
         | astore_1
         | astore_2
         | astore_3
         | athrow
         | baload
         | bastore
         | bipush byte
         | caload
         | castore
         | checkcast indexbyte1 indexbyte2
         | d2f
         | d2i
         | d2l
         | dadd
         | daload
         | dastore
         | dcmpg
         | dcmpl
         | dconst_0
         | dconst_1
         | ddiv
         | dload index
         | dload_0
         | dload_1
         | dload_2
         | dload_3
         | dmul
         | dneg
         | drem
         | dreturn
         | dstore index
         | dstore_0
         | dstore_1
         | dstore_2
         | dstore_3
         | dsub
         | dup
         | dup_x1
         | dup_x2
         | dup2
         | dup2_x1
         | dup2_x2
         | f2d
         | f2i
         | f2l
         | fadd
         | faload
         | fastore
         | fcmpg
         | fcmpl
         | fconst_0
         | fconst_1
         | fconst_2
         | fdiv
         | fload index
         | fload_0
         | fload_1
         | fload_2
         | fload_3
         | fmul
         | fneg
         | frem
         | freturn
         | fstore index
         | fstore_0
         | fstore_1
         | fstore_2
         | fstore_3
         | fsub
         | getfield indexbyte1 indexbyte2
         | getstatic indexbyte1 indexbyte2
         | goto branchbyte1 branchbyte2
         | goto_w branchbyte1 branchbyte2 branchbyte3 branchbyte4
         | i2b
         | i2c
         | i2d
         | i2f
         | i2l
         | i2s
         | iadd
         | iaload
         | iand
         | iastore
         | iconst_m1
         | iconst_0
         | iconst_1
         | iconst_2
         | iconst_3
         | iconst_4
         | iconst_5
         | idiv
         | if_acmpeq branchbyte1 branchbyte2
         | if_acmpne branchbyte1 branchbyte2
         | if_icmpeq branchbyte1 branchbyte2
         | if_icmpne branchbyte1 branchbyte2
         | if_icmplt branchbyte1 branchbyte2
         | if_icmpge branchbyte1 branchbyte2
         | if_icmpgt branchbyte1 branchbyte2
         | if_icmple branchbyte1 branchbyte2
         | ifeq branchbyte1 branchbyte2
         | ifne branchbyte1 branchbyte2
         | iflt branchbyte1 branchbyte2
         | ifge branchbyte1 branchbyte2
         | ifgt branchbyte1 branchbyte2
         | ifle branchbyte1 branchbyte2
         | ifnonnull branchbyte1 branchbyte2
         | ifnull branchbyte1 branchbyte2
         | iinc index const
         | iload index
         | iload_0
         | iload_1
         | iload_2
         | iload_3
         | imul
         | ineg
         | instanceof
         | indexbyte1
         | indexbyte2
         | invokedynamic indexbyte1 indexbyte2 0 0
         | invokeinterface indexbyte1 indexbyte2 count 0
         | invokespecial indexbyte1 indexbyte2
         | invokestatic indexbyte1 indexbyte2
         | invokevirtual indexbyte1 indexbyte2
         | ior
         | irem
         | ireturn
         | ishl
         | ishr
         | istore index
         | istore_0
         | istore_1
         | istore_2
         | istore_3
         | isub
         | iushr
         | ixor
         | jsr branchbyte1 branchbyte2
         | jsr_w branchbyte1 branchbyte2 branchbyte3 branchbyte4
         | l2d
         | l2f
         | l2i
         | ladd
         | laload
         | land
         | lastore
         | lcmp
         | lconst_0
         | lconst_1
         | ldc index
         | ldc_w indexbyte1 indexbyte2
         | ldc2_w indexbyte1 indexbyte2
         | ldiv
         | lload index
         | lload_0
         | lload_1
         | lload_2
         | lload_3
         | lmul
         | lneg
         | lookupswitch padding defaultbyte1 defaultbyte2 defaultbyte3 defaultbyte4 npairs1 npairs2 npairs3 npairs4 match_offset pairs
         | lor
         | lrem
         | lreturn
         | lshl
         | lshr
         | lstore index
         | lstore_0
         | lstore_1
         | lstore_2
         | lstore_3
         | lsub
         | lushr
         | lxor
         | monitorenter
         | monitorexit
         | multianewarray indexbyte1 indexbyte2 dimensions
         | new indexbyte1 indexbyte2
         | newarray atype
         | nop
         | pop
         | pop2
         | putfield indexbyte1 indexbyte2
         | putstatic indexbyte1 indexbyte2
         | ret index
         | return
         | saload
         | sastore
         | sipush byte1 byte2
         | swap
         | tableswitch padding defaultbyte1 defaultbyte2 defaultbyte3 defaultbyte4 lowbyte1 lowbyte2 lowbyte3 lowbyte4 highbyte1 highbyte2 highbyte3 highbyte4 jump offsets
         | wide iload indexbyte1 indexbyte2
         | wide fload indexbyte1 indexbyte2
         | wide aload indexbyte1 indexbyte2
         | wide lload indexbyte1 indexbyte2
         | wide dload indexbyte1 indexbyte2
         | wide istore indexbyte1 indexbyte2
         | wide fstore indexbyte1 indexbyte2
         | wide astore indexbyte1 indexbyte2
         | wide lstore indexbyte1 indexbyte2
         | wide dstore indexbyte1 indexbyte2
         | wide ret indexbyte1 indexbyte2
         | wide iinc indexbyte1 indexbyte2 constbyte1 constbyte2
aaload  ::= [\x{32}]                                                   action => aaload
aastore ::= [\x{53}]                                                   action => aastore
