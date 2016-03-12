use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::OpCode;
use Moo;

# ABSTRACT: Op code

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;
use Types::Common::Numeric -all;

has offset     => ( is => 'ro', required => 1, isa => PositiveOrZeroInt );
has length     => ( is => 'ro', required => 1, isa => PositiveInt );
has mnemonic   => ( is => 'ro', required => 1, isa => Str );
has code       => ( is => 'ro', required => 1, isa => Str );
has parameters => ( is => 'ro', required => 1, isa => ArrayRef );

#
# Do the per-opcode detail in this package
#
package MarpaX::Java::ClassFile::Struct::OpCode::Aaload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Aastore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Aconst_null;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Aload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Aload_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Aload_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Aload_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Aload_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Anewarray;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Areturn;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Arraylength;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Astore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Astore_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Astore_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Astore_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Astore_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Athrow;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Baload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Bastore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Bipush;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Caload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Castore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Checkcast;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::D2f;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::D2i;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::D2l;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dadd;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Daload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dastore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dcmpg;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dcmpl;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dconst_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dconst_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ddiv;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dload_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dload_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dload_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dload_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dmul;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dneg;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Drem;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dreturn;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dstore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dstore_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dstore_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dstore_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dstore_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dsub;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dup;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dup_x1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dup_x2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dup2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dup2_x1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Dup2_x2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::F2d;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::F2i;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::F2l;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fadd;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Faload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fastore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fcmpg;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fcmpl;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fconst_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fconst_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fconst_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fdiv;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fload_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fload_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fload_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fload_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fmul;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fneg;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Frem;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Freturn;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fstore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fstore_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fstore_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fstore_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fstore_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Fsub;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Getfield;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Getstatic;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Goto;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Goto_w;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::I2b;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::I2c;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::I2d;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::I2f;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::I2l;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::I2s;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iadd;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iaload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iand;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iastore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iconst_m1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iconst_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iconst_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iconst_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iconst_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iconst_4;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iconst_5;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Idiv;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_acmpeq;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_acmpne;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_icmpeq;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_icmpne;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_icmplt;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_icmpge;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_icmpgt;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::If_icmple;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ifeq;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ifne;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iflt;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ifge;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ifgt;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ifle;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ifnonnull;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ifnull;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iinc;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iload_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iload_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iload_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iload_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Imul;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ineg;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Instanceof;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Invokedynamic;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Invokeinterface;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Invokespecial;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Invokestatic;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Invokevirtual;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ior;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Irem;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ireturn;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ishl;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ishr;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Istore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Istore_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Istore_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Istore_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Istore_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Isub;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Iushr;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ixor;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Jsr;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Jsr_w;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::L2d;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::L2f;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::L2i;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ladd;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Laload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Land;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lastore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lcmp;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lconst_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lconst_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ldc;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ldc_w;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ldc2_w;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ldiv;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lload_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lload_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lload_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lload_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lmul;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lneg;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lookupswitch;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lor;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lrem;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lreturn;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lshl;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lshr;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lstore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lstore_0;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lstore_1;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lstore_2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lstore_3;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lsub;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lushr;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Lxor;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Monitorenter;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Monitorexit;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Multianewarray;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::New;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Newarray;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Nop;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Pop;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Pop2;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Putfield;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Putstatic;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Ret;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Return;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Saload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Sastore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Sipush;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Swap;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Tableswitch;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_iload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_fload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_aload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_lload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_dload;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_istore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_fstore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_astore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_lstore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_dstore;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_ret;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

package MarpaX::Java::ClassFile::Struct::OpCode::Wide_iinc;
use Moo;

extends 'MarpaX::Java::ClassFile::Struct::OpCode';

1;
