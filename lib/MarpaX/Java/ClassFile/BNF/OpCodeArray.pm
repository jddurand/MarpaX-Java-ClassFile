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
use Types::Common::Numeric -all;
use Class::Method::Modifiers qw/fresh/;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

has _originPos => (is => 'rwp', isa => PositiveOrZeroInt);

sub BUILD {
  #
  # Remember original position to calculate padding of lookupswitch
  #
  $_[0]->_set__originPos($_[0]->pos)
}

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted" => sub { $_[0]->exhausted },
          'opcode$'     => sub { $_[0]->inc_nbDone },
          '^padding'    => sub {
            my $curOffset = $_[0]->pos - $_[0]->_originPos;
            #
            # We want the next offset to be 4-bytes aligned
            #
            $_[0]->lexeme_read_managed($curOffset % 4, 1) # Last argument means ignore events - in fact we know there is none, but at least we gain a call to recognizer's event()

          },
          'npairs$'     => sub {
            #
            # npairs should be > 0
            #
            map { $_[0]->lexeme_read_u4, $_[0]->lexeme_read_u4 } (1..$_[0]->literalSignedU4('npairs'))
          },
          'highbytes$' => sub {
            #
            # highbytes - lowbytes + 1 should be >= 0
            #
            map { $_[0]->lexeme_read_u4 } (1..($_[0]->literalSignedU4('highbytes') - $_[0]->literalSignedU4('lowbytes') + 1))
          }
         }
}

sub _actionOffsetAndLength {
  #
  # In practice, G1 locations represent exactly what we need: offset and offset+length.
  # In theory, the general algorithm to get exact location with respect to the meaning
  # of G1 locations is below (I hope it is correct -;)
  #
  my ($startG1, $endG1) = Marpa::R2::Context::location();
  my $r = $MarpaX::Java::ClassFile::Role::Parser::R;
  my ($startG1Pos, $startG1Length, $endG1Pos, $endG1Length) = ($r->g1_location_to_span($startG1), $r->g1_location_to_span($endG1));
  #
  # G1 location zero does NOT correspond to a range
  #
  my ($start, $end)  = ($startG1 > 0) ? ($startG1Pos + $startG1Length, $endG1Pos + $endG1Length) : ($_[0]->_originPos, $endG1Pos + $endG1Length);
  my ($offset, $length) = ($start - $_[0]->_originPos, $end - $start);
  (offset => $offset, length => $length)
}
#
# For all the actions, we always push the menemonic plus all the arguments
# (no matter if there is none: nothing will be pushed)
#
sub aaload {
  MarpaX::Java::ClassFile::Struct::OpCode::Aaload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aaload', parameters => [ @_[2..$#_] ])
}
sub aastore {
  MarpaX::Java::ClassFile::Struct::OpCode::Aastore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aastore', parameters => [ @_[2..$#_] ])
}
sub aconst_null {
  MarpaX::Java::ClassFile::Struct::OpCode::Aconst_null->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aconst_null', parameters => [ @_[2..$#_] ])
}
sub aload {
  MarpaX::Java::ClassFile::Struct::OpCode::Aload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aload', parameters => [ @_[2..$#_] ])
}
sub aload_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Aload_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aload_0', parameters => [ @_[2..$#_] ])
}
sub aload_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Aload_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aload_1', parameters => [ @_[2..$#_] ])
}
sub aload_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Aload_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aload_2', parameters => [ @_[2..$#_] ])
}
sub aload_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Aload_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'aload_3', parameters => [ @_[2..$#_] ])
}
sub anewarray {
  MarpaX::Java::ClassFile::Struct::OpCode::Anewarray->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'anewarray', parameters => [ @_[2..$#_] ])
}
sub areturn {
  MarpaX::Java::ClassFile::Struct::OpCode::Areturn->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'areturn', parameters => [ @_[2..$#_] ])
}
sub arraylength {
  MarpaX::Java::ClassFile::Struct::OpCode::Arraylength->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'arraylength', parameters => [ @_[2..$#_] ])
}
sub astore {
  MarpaX::Java::ClassFile::Struct::OpCode::Astore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'astore', parameters => [ @_[2..$#_] ])
}
sub astore_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Astore_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'astore_0', parameters => [ @_[2..$#_] ])
}
sub astore_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Astore_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'astore_1', parameters => [ @_[2..$#_] ])
}
sub astore_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Astore_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'astore_2', parameters => [ @_[2..$#_] ])
}
sub astore_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Astore_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'astore_3', parameters => [ @_[2..$#_] ])
}
sub athrow {
  MarpaX::Java::ClassFile::Struct::OpCode::Athrow->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'athrow', parameters => [ @_[2..$#_] ])
}
sub baload {
  MarpaX::Java::ClassFile::Struct::OpCode::Baload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'baload', parameters => [ @_[2..$#_] ])
}
sub bastore {
  MarpaX::Java::ClassFile::Struct::OpCode::Bastore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'bastore', parameters => [ @_[2..$#_] ])
}
sub bipush {
  MarpaX::Java::ClassFile::Struct::OpCode::Bipush->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'bipush', parameters => [ @_[2..$#_] ])
}
sub caload {
  MarpaX::Java::ClassFile::Struct::OpCode::Caload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'caload', parameters => [ @_[2..$#_] ])
}
sub castore {
  MarpaX::Java::ClassFile::Struct::OpCode::Castore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'castore', parameters => [ @_[2..$#_] ])
}
sub checkcast {
  MarpaX::Java::ClassFile::Struct::OpCode::Checkcast->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'checkcast', parameters => [ @_[2..$#_] ])
}
sub d2f {
  MarpaX::Java::ClassFile::Struct::OpCode::D2f->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'd2f', parameters => [ @_[2..$#_] ])
}
sub d2i {
  MarpaX::Java::ClassFile::Struct::OpCode::D2i->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'd2i', parameters => [ @_[2..$#_] ])
}
sub d2l {
  MarpaX::Java::ClassFile::Struct::OpCode::D2l->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'd2l', parameters => [ @_[2..$#_] ])
}
sub dadd {
  MarpaX::Java::ClassFile::Struct::OpCode::Dadd->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dadd', parameters => [ @_[2..$#_] ])
}
sub daload {
  MarpaX::Java::ClassFile::Struct::OpCode::Daload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'daload', parameters => [ @_[2..$#_] ])
}
sub dastore {
  MarpaX::Java::ClassFile::Struct::OpCode::Dastore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dastore', parameters => [ @_[2..$#_] ])
}
sub dcmpg {
  MarpaX::Java::ClassFile::Struct::OpCode::Dcmpg->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dcmpg', parameters => [ @_[2..$#_] ])
}
sub dcmpl {
  MarpaX::Java::ClassFile::Struct::OpCode::Dcmpl->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dcmpl', parameters => [ @_[2..$#_] ])
}
sub dconst_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dconst_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dconst_0', parameters => [ @_[2..$#_] ])
}
sub dconst_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dconst_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dconst_1', parameters => [ @_[2..$#_] ])
}
sub ddiv {
  MarpaX::Java::ClassFile::Struct::OpCode::Ddiv->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ddiv', parameters => [ @_[2..$#_] ])
}
sub dload {
  MarpaX::Java::ClassFile::Struct::OpCode::Dload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dload', parameters => [ @_[2..$#_] ])
}
sub dload_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dload_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dload_0', parameters => [ @_[2..$#_] ])
}
sub dload_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dload_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dload_1', parameters => [ @_[2..$#_] ])
}
sub dload_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dload_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dload_2', parameters => [ @_[2..$#_] ])
}
sub dload_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dload_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dload_3', parameters => [ @_[2..$#_] ])
}
sub dmul {
  MarpaX::Java::ClassFile::Struct::OpCode::Dmul->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dmul', parameters => [ @_[2..$#_] ])
}
sub dneg {
  MarpaX::Java::ClassFile::Struct::OpCode::Dneg->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dneg', parameters => [ @_[2..$#_] ])
}
sub drem {
  MarpaX::Java::ClassFile::Struct::OpCode::Drem->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'drem', parameters => [ @_[2..$#_] ])
}
sub dreturn {
  MarpaX::Java::ClassFile::Struct::OpCode::Dreturn->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dreturn', parameters => [ @_[2..$#_] ])
}
sub dstore {
  MarpaX::Java::ClassFile::Struct::OpCode::Dstore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dstore', parameters => [ @_[2..$#_] ])
}
sub dstore_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dstore_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dstore_0', parameters => [ @_[2..$#_] ])
}
sub dstore_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dstore_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dstore_1', parameters => [ @_[2..$#_] ])
}
sub dstore_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dstore_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dstore_2', parameters => [ @_[2..$#_] ])
}
sub dstore_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dstore_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dstore_3', parameters => [ @_[2..$#_] ])
}
sub dsub {
  MarpaX::Java::ClassFile::Struct::OpCode::Dsub->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dsub', parameters => [ @_[2..$#_] ])
}
sub dup {
  MarpaX::Java::ClassFile::Struct::OpCode::Dup->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dup', parameters => [ @_[2..$#_] ])
}
sub dup_x1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dup_x1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dup_x1', parameters => [ @_[2..$#_] ])
}
sub dup_x2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dup_x2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dup_x2', parameters => [ @_[2..$#_] ])
}
sub dup2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dup2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dup2', parameters => [ @_[2..$#_] ])
}
sub dup2_x1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dup2_x1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dup2_x1', parameters => [ @_[2..$#_] ])
}
sub dup2_x2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Dup2_x2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'dup2_x2', parameters => [ @_[2..$#_] ])
}
sub f2d {
  MarpaX::Java::ClassFile::Struct::OpCode::F2d->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'f2d', parameters => [ @_[2..$#_] ])
}
sub f2i {
  MarpaX::Java::ClassFile::Struct::OpCode::F2i->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'f2i', parameters => [ @_[2..$#_] ])
}
sub f2l {
  MarpaX::Java::ClassFile::Struct::OpCode::F2l->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'f2l', parameters => [ @_[2..$#_] ])
}
sub fadd {
  MarpaX::Java::ClassFile::Struct::OpCode::Fadd->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fadd', parameters => [ @_[2..$#_] ])
}
sub faload {
  MarpaX::Java::ClassFile::Struct::OpCode::Faload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'faload', parameters => [ @_[2..$#_] ])
}
sub fastore {
  MarpaX::Java::ClassFile::Struct::OpCode::Fastore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fastore', parameters => [ @_[2..$#_] ])
}
sub fcmpg {
  MarpaX::Java::ClassFile::Struct::OpCode::Fcmpg->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fcmpg', parameters => [ @_[2..$#_] ])
}
sub fcmpl {
  MarpaX::Java::ClassFile::Struct::OpCode::Fcmpl->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fcmpl', parameters => [ @_[2..$#_] ])
}
sub fconst_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fconst_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fconst_0', parameters => [ @_[2..$#_] ])
}
sub fconst_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fconst_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fconst_1', parameters => [ @_[2..$#_] ])
}
sub fconst_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fconst_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fconst_2', parameters => [ @_[2..$#_] ])
}
sub fdiv {
  MarpaX::Java::ClassFile::Struct::OpCode::Fdiv->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fdiv', parameters => [ @_[2..$#_] ])
}
sub fload {
  MarpaX::Java::ClassFile::Struct::OpCode::Fload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fload', parameters => [ @_[2..$#_] ])
}
sub fload_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fload_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fload_0', parameters => [ @_[2..$#_] ])
}
sub fload_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fload_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fload_1', parameters => [ @_[2..$#_] ])
}
sub fload_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fload_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fload_2', parameters => [ @_[2..$#_] ])
}
sub fload_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fload_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fload_3', parameters => [ @_[2..$#_] ])
}
sub fmul {
  MarpaX::Java::ClassFile::Struct::OpCode::Fmul->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fmul', parameters => [ @_[2..$#_] ])
}
sub fneg {
  MarpaX::Java::ClassFile::Struct::OpCode::Fneg->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fneg', parameters => [ @_[2..$#_] ])
}
sub frem {
  MarpaX::Java::ClassFile::Struct::OpCode::Frem->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'frem', parameters => [ @_[2..$#_] ])
}
sub freturn {
  MarpaX::Java::ClassFile::Struct::OpCode::Freturn->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'freturn', parameters => [ @_[2..$#_] ])
}
sub fstore {
  MarpaX::Java::ClassFile::Struct::OpCode::Fstore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fstore', parameters => [ @_[2..$#_] ])
}
sub fstore_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fstore_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fstore_0', parameters => [ @_[2..$#_] ])
}
sub fstore_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fstore_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fstore_1', parameters => [ @_[2..$#_] ])
}
sub fstore_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fstore_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fstore_2', parameters => [ @_[2..$#_] ])
}
sub fstore_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Fstore_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fstore_3', parameters => [ @_[2..$#_] ])
}
sub fsub {
  MarpaX::Java::ClassFile::Struct::OpCode::Fsub->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'fsub', parameters => [ @_[2..$#_] ])
}
sub getfield {
  MarpaX::Java::ClassFile::Struct::OpCode::Getfield->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'getfield', parameters => [ @_[2..$#_] ])
}
sub getstatic {
  MarpaX::Java::ClassFile::Struct::OpCode::Getstatic->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'getstatic', parameters => [ @_[2..$#_] ])
}
sub _goto {
  MarpaX::Java::ClassFile::Struct::OpCode::Goto->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'goto', parameters => [ @_[2..$#_] ])
}
sub goto_w {
  MarpaX::Java::ClassFile::Struct::OpCode::Goto_w->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'goto_w', parameters => [ @_[2..$#_] ])
}
sub i2b {
  MarpaX::Java::ClassFile::Struct::OpCode::I2b->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'i2b', parameters => [ @_[2..$#_] ])
}
sub i2c {
  MarpaX::Java::ClassFile::Struct::OpCode::I2c->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'i2c', parameters => [ @_[2..$#_] ])
}
sub i2d {
  MarpaX::Java::ClassFile::Struct::OpCode::I2d->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'i2d', parameters => [ @_[2..$#_] ])
}
sub i2f {
  MarpaX::Java::ClassFile::Struct::OpCode::I2f->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'i2f', parameters => [ @_[2..$#_] ])
}
sub i2l {
  MarpaX::Java::ClassFile::Struct::OpCode::I2l->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'i2l', parameters => [ @_[2..$#_] ])
}
sub i2s {
  MarpaX::Java::ClassFile::Struct::OpCode::I2s->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'i2s', parameters => [ @_[2..$#_] ])
}
sub iadd {
  MarpaX::Java::ClassFile::Struct::OpCode::Iadd->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iadd', parameters => [ @_[2..$#_] ])
}
sub iaload {
  MarpaX::Java::ClassFile::Struct::OpCode::Iaload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iaload', parameters => [ @_[2..$#_] ])
}
sub iand {
  MarpaX::Java::ClassFile::Struct::OpCode::Iand->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iand', parameters => [ @_[2..$#_] ])
}
sub iastore {
  MarpaX::Java::ClassFile::Struct::OpCode::Iastore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iastore', parameters => [ @_[2..$#_] ])
}
sub iconst_m1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iconst_m1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iconst_m1', parameters => [ @_[2..$#_] ])
}
sub iconst_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iconst_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iconst_0', parameters => [ @_[2..$#_] ])
}
sub iconst_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iconst_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iconst_1', parameters => [ @_[2..$#_] ])
}
sub iconst_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iconst_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iconst_2', parameters => [ @_[2..$#_] ])
}
sub iconst_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iconst_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iconst_3', parameters => [ @_[2..$#_] ])
}
sub iconst_4 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iconst_4->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iconst_4', parameters => [ @_[2..$#_] ])
}
sub iconst_5 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iconst_5->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iconst_5', parameters => [ @_[2..$#_] ])
}
sub idiv {
  MarpaX::Java::ClassFile::Struct::OpCode::Idiv->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'idiv', parameters => [ @_[2..$#_] ])
}
sub if_acmpeq {
  MarpaX::Java::ClassFile::Struct::OpCode::If_acmpeq->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_acmpeq', parameters => [ @_[2..$#_] ])
}
sub if_acmpne {
  MarpaX::Java::ClassFile::Struct::OpCode::If_acmpne->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_acmpne', parameters => [ @_[2..$#_] ])
}
sub if_icmpeq {
  MarpaX::Java::ClassFile::Struct::OpCode::If_icmpeq->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_icmpeq', parameters => [ @_[2..$#_] ])
}
sub if_icmpne {
  MarpaX::Java::ClassFile::Struct::OpCode::If_icmpne->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_icmpne', parameters => [ @_[2..$#_] ])
}
sub if_icmplt {
  MarpaX::Java::ClassFile::Struct::OpCode::If_icmplt->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_icmplt', parameters => [ @_[2..$#_] ])
}
sub if_icmpge {
  MarpaX::Java::ClassFile::Struct::OpCode::If_icmpge->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_icmpge', parameters => [ @_[2..$#_] ])
}
sub if_icmpgt {
  MarpaX::Java::ClassFile::Struct::OpCode::If_icmpgt->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_icmpgt', parameters => [ @_[2..$#_] ])
}
sub if_icmple {
  MarpaX::Java::ClassFile::Struct::OpCode::If_icmple->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'if_icmple', parameters => [ @_[2..$#_] ])
}
sub ifeq {
  MarpaX::Java::ClassFile::Struct::OpCode::Ifeq->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ifeq', parameters => [ @_[2..$#_] ])
}
sub ifne {
  MarpaX::Java::ClassFile::Struct::OpCode::Ifne->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ifne', parameters => [ @_[2..$#_] ])
}
sub iflt {
  MarpaX::Java::ClassFile::Struct::OpCode::Iflt->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iflt', parameters => [ @_[2..$#_] ])
}
sub ifge {
  MarpaX::Java::ClassFile::Struct::OpCode::Ifge->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ifge', parameters => [ @_[2..$#_] ])
}
sub ifgt {
  MarpaX::Java::ClassFile::Struct::OpCode::Ifgt->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ifgt', parameters => [ @_[2..$#_] ])
}
sub ifle {
  MarpaX::Java::ClassFile::Struct::OpCode::Ifle->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ifle', parameters => [ @_[2..$#_] ])
}
sub ifnonnull {
  MarpaX::Java::ClassFile::Struct::OpCode::Ifnonnull->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ifnonnull', parameters => [ @_[2..$#_] ])
}
sub ifnull {
  MarpaX::Java::ClassFile::Struct::OpCode::Ifnull->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ifnull', parameters => [ @_[2..$#_] ])
}
sub iinc {
  MarpaX::Java::ClassFile::Struct::OpCode::Iinc->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iinc', parameters => [ @_[2..$#_] ])
}
sub iload {
  MarpaX::Java::ClassFile::Struct::OpCode::Iload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iload', parameters => [ @_[2..$#_] ])
}
sub iload_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iload_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iload_0', parameters => [ @_[2..$#_] ])
}
sub iload_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iload_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iload_1', parameters => [ @_[2..$#_] ])
}
sub iload_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iload_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iload_2', parameters => [ @_[2..$#_] ])
}
sub iload_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Iload_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iload_3', parameters => [ @_[2..$#_] ])
}
sub imul {
  MarpaX::Java::ClassFile::Struct::OpCode::Imul->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'imul', parameters => [ @_[2..$#_] ])
}
sub ineg {
  MarpaX::Java::ClassFile::Struct::OpCode::Ineg->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ineg', parameters => [ @_[2..$#_] ])
}
sub instanceof {
  MarpaX::Java::ClassFile::Struct::OpCode::Instanceof->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'instanceof', parameters => [ @_[2..$#_] ])
}
sub invokedynamic {
  MarpaX::Java::ClassFile::Struct::OpCode::Invokedynamic->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'invokedynamic', parameters => [ @_[2..$#_] ])
}
sub invokeinterface {
  MarpaX::Java::ClassFile::Struct::OpCode::Invokeinterface->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'invokeinterface', parameters => [ @_[2..$#_] ])
}
sub invokespecial {
  MarpaX::Java::ClassFile::Struct::OpCode::Invokespecial->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'invokespecial', parameters => [ @_[2..$#_] ])
}
sub invokestatic {
  MarpaX::Java::ClassFile::Struct::OpCode::Invokestatic->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'invokestatic', parameters => [ @_[2..$#_] ])
}
sub invokevirtual {
  MarpaX::Java::ClassFile::Struct::OpCode::Invokevirtual->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'invokevirtual', parameters => [ @_[2..$#_] ])
}
sub ior {
  MarpaX::Java::ClassFile::Struct::OpCode::Ior->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ior', parameters => [ @_[2..$#_] ])
}
sub irem {
  MarpaX::Java::ClassFile::Struct::OpCode::Irem->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'irem', parameters => [ @_[2..$#_] ])
}
sub ireturn {
  MarpaX::Java::ClassFile::Struct::OpCode::Ireturn->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ireturn', parameters => [ @_[2..$#_] ])
}
sub ishl {
  MarpaX::Java::ClassFile::Struct::OpCode::Ishl->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ishl', parameters => [ @_[2..$#_] ])
}
sub ishr {
  MarpaX::Java::ClassFile::Struct::OpCode::Ishr->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ishr', parameters => [ @_[2..$#_] ])
}
sub istore {
  MarpaX::Java::ClassFile::Struct::OpCode::Istore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'istore', parameters => [ @_[2..$#_] ])
}
sub istore_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Istore_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'istore_0', parameters => [ @_[2..$#_] ])
}
sub istore_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Istore_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'istore_1', parameters => [ @_[2..$#_] ])
}
sub istore_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Istore_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'istore_2', parameters => [ @_[2..$#_] ])
}
sub istore_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Istore_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'istore_3', parameters => [ @_[2..$#_] ])
}
sub isub {
  MarpaX::Java::ClassFile::Struct::OpCode::Isub->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'isub', parameters => [ @_[2..$#_] ])
}
sub iushr {
  MarpaX::Java::ClassFile::Struct::OpCode::Iushr->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'iushr', parameters => [ @_[2..$#_] ])
}
sub ixor {
  MarpaX::Java::ClassFile::Struct::OpCode::Ixor->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ixor', parameters => [ @_[2..$#_] ])
}
sub jsr {
  MarpaX::Java::ClassFile::Struct::OpCode::Jsr->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'jsr', parameters => [ @_[2..$#_] ])
}
sub jsr_w {
  MarpaX::Java::ClassFile::Struct::OpCode::Jsr_w->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'jsr_w', parameters => [ @_[2..$#_] ])
}
sub l2d {
  MarpaX::Java::ClassFile::Struct::OpCode::L2d->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'l2d', parameters => [ @_[2..$#_] ])
}
sub l2f {
  MarpaX::Java::ClassFile::Struct::OpCode::L2f->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'l2f', parameters => [ @_[2..$#_] ])
}
sub l2i {
  MarpaX::Java::ClassFile::Struct::OpCode::L2i->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'l2i', parameters => [ @_[2..$#_] ])
}
sub ladd {
  MarpaX::Java::ClassFile::Struct::OpCode::Ladd->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ladd', parameters => [ @_[2..$#_] ])
}
sub laload {
  MarpaX::Java::ClassFile::Struct::OpCode::Laload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'laload', parameters => [ @_[2..$#_] ])
}
sub land {
  MarpaX::Java::ClassFile::Struct::OpCode::Land->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'land', parameters => [ @_[2..$#_] ])
}
sub lastore {
  MarpaX::Java::ClassFile::Struct::OpCode::Lastore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lastore', parameters => [ @_[2..$#_] ])
}
sub lcmp {
  MarpaX::Java::ClassFile::Struct::OpCode::Lcmp->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lcmp', parameters => [ @_[2..$#_] ])
}
sub lconst_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lconst_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lconst_0', parameters => [ @_[2..$#_] ])
}
sub lconst_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lconst_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lconst_1', parameters => [ @_[2..$#_] ])
}
sub ldc {
  MarpaX::Java::ClassFile::Struct::OpCode::Ldc->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ldc', parameters => [ @_[2..$#_] ])
}
sub ldc_w {
  MarpaX::Java::ClassFile::Struct::OpCode::Ldc_w->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ldc_w', parameters => [ @_[2..$#_] ])
}
sub ldc2_w {
  MarpaX::Java::ClassFile::Struct::OpCode::Ldc2_w->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ldc2_w', parameters => [ @_[2..$#_] ])
}
sub ldiv {
  MarpaX::Java::ClassFile::Struct::OpCode::Ldiv->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ldiv', parameters => [ @_[2..$#_] ])
}
sub lload {
  MarpaX::Java::ClassFile::Struct::OpCode::Lload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lload', parameters => [ @_[2..$#_] ])
}
sub lload_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lload_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lload_0', parameters => [ @_[2..$#_] ])
}
sub lload_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lload_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lload_1', parameters => [ @_[2..$#_] ])
}
sub lload_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lload_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lload_2', parameters => [ @_[2..$#_] ])
}
sub lload_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lload_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lload_3', parameters => [ @_[2..$#_] ])
}
sub lmul {
  MarpaX::Java::ClassFile::Struct::OpCode::Lmul->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lmul', parameters => [ @_[2..$#_] ])
}
sub lneg {
  MarpaX::Java::ClassFile::Struct::OpCode::Lneg->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lneg', parameters => [ @_[2..$#_] ])
}
sub lookupswitch {
  MarpaX::Java::ClassFile::Struct::OpCode::Lookupswitch->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lookupswitch', parameters => [ @_[2..$#_] ])
}
sub lor {
  MarpaX::Java::ClassFile::Struct::OpCode::Lor->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lor', parameters => [ @_[2..$#_] ])
}
sub lrem {
  MarpaX::Java::ClassFile::Struct::OpCode::Lrem->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lrem', parameters => [ @_[2..$#_] ])
}
sub lreturn {
  MarpaX::Java::ClassFile::Struct::OpCode::Lreturn->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lreturn', parameters => [ @_[2..$#_] ])
}
sub lshl {
  MarpaX::Java::ClassFile::Struct::OpCode::Lshl->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lshl', parameters => [ @_[2..$#_] ])
}
sub lshr {
  MarpaX::Java::ClassFile::Struct::OpCode::Lshr->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lshr', parameters => [ @_[2..$#_] ])
}
sub lstore {
  MarpaX::Java::ClassFile::Struct::OpCode::Lstore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lstore', parameters => [ @_[2..$#_] ])
}
sub lstore_0 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lstore_0->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lstore_0', parameters => [ @_[2..$#_] ])
}
sub lstore_1 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lstore_1->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lstore_1', parameters => [ @_[2..$#_] ])
}
sub lstore_2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lstore_2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lstore_2', parameters => [ @_[2..$#_] ])
}
sub lstore_3 {
  MarpaX::Java::ClassFile::Struct::OpCode::Lstore_3->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lstore_3', parameters => [ @_[2..$#_] ])
}
sub lsub {
  MarpaX::Java::ClassFile::Struct::OpCode::Lsub->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lsub', parameters => [ @_[2..$#_] ])
}
sub lushr {
  MarpaX::Java::ClassFile::Struct::OpCode::Lushr->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lushr', parameters => [ @_[2..$#_] ])
}
sub lxor {
  MarpaX::Java::ClassFile::Struct::OpCode::Lxor->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'lxor', parameters => [ @_[2..$#_] ])
}
sub monitorenter {
  MarpaX::Java::ClassFile::Struct::OpCode::Monitorenter->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'monitorenter', parameters => [ @_[2..$#_] ])
}
sub monitorexit {
  MarpaX::Java::ClassFile::Struct::OpCode::Monitorexit->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'monitorexit', parameters => [ @_[2..$#_] ])
}
sub multianewarray {
  MarpaX::Java::ClassFile::Struct::OpCode::Multianewarray->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'multianewarray', parameters => [ @_[2..$#_] ])
}
sub _new {
  MarpaX::Java::ClassFile::Struct::OpCode::New->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'new', parameters => [ @_[2..$#_] ])
}
sub newarray {
  MarpaX::Java::ClassFile::Struct::OpCode::Newarray->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'newarray', parameters => [ @_[2..$#_] ])
}
sub nop {
  MarpaX::Java::ClassFile::Struct::OpCode::Nop->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'nop', parameters => [ @_[2..$#_] ])
}
sub _pop {
  MarpaX::Java::ClassFile::Struct::OpCode::Pop->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'pop', parameters => [ @_[2..$#_] ])
}
sub pop2 {
  MarpaX::Java::ClassFile::Struct::OpCode::Pop2->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'pop2', parameters => [ @_[2..$#_] ])
}
sub putfield {
  MarpaX::Java::ClassFile::Struct::OpCode::Putfield->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'putfield', parameters => [ @_[2..$#_] ])
}
sub putstatic {
  MarpaX::Java::ClassFile::Struct::OpCode::Putstatic->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'putstatic', parameters => [ @_[2..$#_] ])
}
sub ret {
  MarpaX::Java::ClassFile::Struct::OpCode::Ret->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'ret', parameters => [ @_[2..$#_] ])
}
sub _return {
  MarpaX::Java::ClassFile::Struct::OpCode::Return->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'return', parameters => [ @_[2..$#_] ])
}
sub saload {
  MarpaX::Java::ClassFile::Struct::OpCode::Saload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'saload', parameters => [ @_[2..$#_] ])
}
sub sastore {
  MarpaX::Java::ClassFile::Struct::OpCode::Sastore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'sastore', parameters => [ @_[2..$#_] ])
}
sub sipush {
  MarpaX::Java::ClassFile::Struct::OpCode::Sipush->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'sipush', parameters => [ @_[2..$#_] ])
}
sub swap {
  MarpaX::Java::ClassFile::Struct::OpCode::Swap->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'swap', parameters => [ @_[2..$#_] ])
}
sub tableswitch {
  MarpaX::Java::ClassFile::Struct::OpCode::Tableswitch->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'tableswitch', parameters => [ @_[2..$#_] ])
}
sub wide_iload {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_iload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_fload {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_fload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_aload {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_aload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_lload {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_lload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_dload {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_dload->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_istore {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_istore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_fstore {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_fstore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_astore {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_astore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_lstore {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_lstore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_dstore {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_dstore->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_ret {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_ret->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}
sub wide_iinc {
  MarpaX::Java::ClassFile::Struct::OpCode::Wide_iinc->new($_[0]->_actionOffsetAndLength, code => $_[1], mnemonic => 'wide', parameters => [ @_[2..$#_] ])
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'opcode$' = completed opcode
event '^padding' = predicted padding
event 'npairs$' = completed npairs
event 'highbytes$' = completed highbytes

opcodeArray ::= opcode* action => [values]

opcode ::= aaload                                                             action => aaload
         | aastore                                                            action => aastore
         | aconst_null                                                        action => aconst_null
         | aload u1                                                           action => aload
         | aload_0                                                            action => aload_0
         | aload_1                                                            action => aload_1
         | aload_2                                                            action => aload_2
         | aload_3                                                            action => aload_0
         | anewarray u2                                                       action => anewarray
         | areturn                                                            action => areturn
         | arraylength                                                        action => arraylength
         | astore u1                                                          action => astore
         | astore_0                                                           action => astore_0
         | astore_1                                                           action => astore_1
         | astore_2                                                           action => astore_2
         | astore_3                                                           action => astore_3
         | athrow                                                             action => athrow
         | baload                                                             action => baload
         | bastore                                                            action => bastore
         | bipush signedU1                                                    action => bipush
         | caload                                                             action => caload
         | castore                                                            action => castore
         | checkcast u2                                                       action => checkcast
         | d2f                                                                action => d2f
         | d2i                                                                action => d2i
         | d2l                                                                action => d2l
         | dadd                                                               action => dadd
         | daload                                                             action => daload
         | dastore                                                            action => dastore
         | dcmpg                                                              action => dcmpg
         | dcmpl                                                              action => dcmpl
         | dconst_0                                                           action => dconst_0
         | dconst_1                                                           action => dconst_1
         | ddiv                                                               action => ddiv
         | dload u1                                                           action => dload
         | dload_0                                                            action => dload_0
         | dload_1                                                            action => dload_1
         | dload_2                                                            action => dload_2
         | dload_3                                                            action => dload_3
         | dmul                                                               action => dmul
         | dneg                                                               action => dneg
         | drem                                                               action => drem
         | dreturn                                                            action => dreturn
         | dstore u1                                                          action => dstore
         | dstore_0                                                           action => dstore_0
         | dstore_1                                                           action => dstore_1
         | dstore_2                                                           action => dstore_2
         | dstore_3                                                           action => dstore_3
         | dsub                                                               action => dsub
         | dup                                                                action => dup
         | dup_x1                                                             action => dup_x1
         | dup_x2                                                             action => dup_x2
         | dup2                                                               action => dup2
         | dup2_x1                                                            action => dup2_x1
         | dup2_x2                                                            action => dup2_x2
         | f2d                                                                action => f2d
         | f2i                                                                action => f2i
         | f2l                                                                action => f2l
         | fadd                                                               action => fadd
         | faload                                                             action => faload
         | fastore                                                            action => fastore
         | fcmpg                                                              action => fcmpg
         | fcmpl                                                              action => fcmpl
         | fconst_0                                                           action => fconst_0
         | fconst_1                                                           action => fconst_1
         | fconst_2                                                           action => fconst_2
         | fdiv                                                               action => fdiv
         | fload u1                                                           action => fload
         | fload_0                                                            action => fload_0
         | fload_1                                                            action => fload_1
         | fload_2                                                            action => fload_2
         | fload_3                                                            action => fload_3
         | fmul                                                               action => fmul
         | fneg                                                               action => fneg
         | frem                                                               action => frem
         | freturn                                                            action => freturn
         | fstore u1                                                          action => fstore
         | fstore_0                                                           action => fstore_0
         | fstore_1                                                           action => fstore_1
         | fstore_2                                                           action => fstore_2
         | fstore_3                                                           action => fstore_3
         | fsub                                                               action => fsub
         | getfield u2                                                        action => getfield
         | getstatic u2                                                       action => getstatic
         | goto u2                                                            action => _goto
         | goto_w u4                                                          action => goto_w
         | i2b                                                                action => i2b
         | i2c                                                                action => i2c
         | i2d                                                                action => i2d
         | i2f                                                                action => i2f
         | i2l                                                                action => i2l
         | i2s                                                                action => i2s
         | iadd                                                               action => iadd
         | iaload                                                             action => iaload
         | iand                                                               action => iand
         | iastore                                                            action => iastore
         | iconst_m1                                                          action => iconst_m1
         | iconst_0                                                           action => iconst_0
         | iconst_1                                                           action => iconst_1
         | iconst_2                                                           action => iconst_2
         | iconst_3                                                           action => iconst_3
         | iconst_4                                                           action => iconst_4
         | iconst_5                                                           action => iconst_5
         | idiv                                                               action => idiv
         | if_acmpeq signedU2                                                 action => if_acmpeq
         | if_acmpne signedU2                                                 action => if_acmpne
         | if_icmpeq signedU2                                                 action => if_icmpeq
         | if_icmpne signedU2                                                 action => if_icmpne
         | if_icmplt signedU2                                                 action => if_icmplt
         | if_icmpge signedU2                                                 action => if_icmpge
         | if_icmpgt signedU2                                                 action => if_icmpgt
         | if_icmple signedU2                                                 action => if_icmple
         | ifeq signedU2                                                      action => ifeq
         | ifne signedU2                                                      action => ifne
         | iflt signedU2                                                      action => iflt
         | ifge signedU2                                                      action => ifge
         | ifgt signedU2                                                      action => ifgt
         | ifle signedU2                                                      action => ifle
         | ifnonnull signedU2                                                 action => ifnonnull
         | ifnull signedU2                                                    action => ifnull
         | iinc u1 signedU1                                                   action => iinc
         | iload u1                                                           action => iload
         | iload_0                                                            action => iload_0
         | iload_1                                                            action => iload_1
         | iload_2                                                            action => iload_2
         | iload_3                                                            action => iload_3
         | imul                                                               action => imul
         | ineg                                                               action => ineg
         | instanceof u2                                                      action => instanceof
         | invokedynamic u2 (zero zero)                                       action => invokedynamic
         | invokeinterface u2 u1 (zero)                                       action => invokeinterface
         | invokespecial u2                                                   action => invokespecial
         | invokestatic u2                                                    action => invokestatic
         | invokevirtual u2                                                   action => invokevirtual
         | ior                                                                action => ior
         | irem                                                               action => irem
         | ireturn                                                            action => ireturn
         | ishl                                                               action => ishl
         | ishr                                                               action => ishr
         | istore u1                                                          action => istore
         | istore_0                                                           action => istore_0
         | istore_1                                                           action => istore_1
         | istore_2                                                           action => istore_2
         | istore_3                                                           action => istore_3
         | isub                                                               action => isub
         | iushr                                                              action => iushr
         | ixor                                                               action => ixor
         | jsr signedU1                                                       action => jsr
         | jsr_w signedU4                                                     action => jsr_w
         | l2d                                                                action => l2d
         | l2f                                                                action => l2f
         | l2i                                                                action => l2i
         | ladd                                                               action => ladd
         | laload                                                             action => laload
         | land                                                               action => land
         | lastore                                                            action => lastore
         | lcmp                                                               action => lcmp
         | lconst_0                                                           action => lconst_0
         | lconst_1                                                           action => lconst_1
         | ldc u1                                                             action => ldc
         | ldc_w u2                                                           action => ldc_w
         | ldc2_w u2                                                          action => ldc2_w
         | ldiv                                                               action => ldiv
         | lload u1                                                           action => lload
         | lload_0                                                            action => lload_0
         | lload_1                                                            action => lload_1
         | lload_2                                                            action => lload_2
         | lload_3                                                            action => lload_3
         | lmul                                                               action => lmul
         | lneg                                                               action => lneg
         | lookupswitch padding signedU4 npairs match_offset_pairs            action => lookupswitch
         | lor                                                                action => lor
         | lrem                                                               action => lrem
         | lreturn                                                            action => lreturn
         | lshl                                                               action => lshl
         | lshr                                                               action => lshr
         | lstore u1                                                          action => lstore
         | lstore_0                                                           action => lstore_0
         | lstore_1                                                           action => lstore_1
         | lstore_2                                                           action => lstore_2
         | lstore_3                                                           action => lstore_3
         | lsub                                                               action => lsub
         | lushr                                                              action => lushr
         | lxor                                                               action => lxor
         | monitorenter                                                       action => monitorenter
         | monitorexit                                                        action => monitorexit
         | multianewarray u2 u1                                               action => multianewarray
         | new u2                                                             action => _new
         # Please note that the spec does NOT say how many bytes takes newarray parameter!
         | newarray u1                                                        action => newarray
         | nop                                                                action => nop
         | pop                                                                action => _pop
         | pop2                                                               action => pop2
         | putfield u2                                                        action => putfield
         | putstatic u2                                                       action => putstatic
         | ret u1                                                             action => ret
         | return                                                             action => _return
         | saload                                                             action => saload
         | sastore                                                            action => sastore
         | sipush u2                                                          action => sipush
         | swap                                                               action => swap
         | tableswitch padding signedU4 lowbytes highbytes jump_offsets       action => tableswitch
         | wide iload u2                                                      action => wide_iload
         | wide fload u2                                                      action => wide_fload
         | wide aload u2                                                      action => wide_aload
         | wide lload u2                                                      action => wide_lload
         | wide dload u2                                                      action => wide_dload
         | wide istore u2                                                     action => wide_istore
         | wide fstore u2                                                     action => wide_fstore
         | wide astore u2                                                     action => wide_astore
         | wide lstore u2                                                     action => wide_lstore
         | wide dstore u2                                                     action => wide_dstore
         | wide ret u2                                                        action => wide_ret
         | wide iinc u2 u2                                                    action => wide_iinc

zero            ::= [\x{00}]
u1              ::= U1                                                         action => u1
signedU1        ::= U1                                                         action => signedU1
u2              ::= U2                                                         action => u2
signedU2        ::= U2                                                         action => signedU2
u4              ::= U4                                                         action => u4
signedU4        ::= U4                                                         action => signedU4
padding         ::= MANAGED
#
# For lookupswitch
#
npairs             ::= signedU4
match_offset_pairs ::= match_offset_pair*                                      action => [values]
match_offset_pair  ::= signedU4 signedU4                                       action => [values]
#
# For tableswitch
#
highbytes       ::= signedU4
lowbytes        ::= signedU4
jump_offsets    ::= jump_offset*                                               action => [values]
jump_offset     ::= signedU4

aaload          ::= [\x{32}]                                                   action => u1
aastore         ::= [\x{53}]                                                   action => u1
aconst_null     ::= [\x{01}]                                                   action => u1
aload           ::= [\x{19}]                                                   action => u1
aload_0         ::= [\x{2a}]                                                   action => u1
aload_1         ::= [\x{2b}]                                                   action => u1
aload_2         ::= [\x{2c}]                                                   action => u1
aload_3         ::= [\x{2d}]                                                   action => u1
anewarray       ::= [\x{bd}]                                                   action => u1
areturn         ::= [\x{b0}]                                                   action => u1
arraylength     ::= [\x{be}]                                                   action => u1
astore          ::= [\x{3a}]                                                   action => u1
astore_0        ::= [\x{4b}]                                                   action => u1
astore_1        ::= [\x{4c}]                                                   action => u1
astore_2        ::= [\x{4d}]                                                   action => u1
astore_3        ::= [\x{4e}]                                                   action => u1
athrow          ::= [\x{bf}]                                                   action => u1
baload          ::= [\x{33}]                                                   action => u1
bastore         ::= [\x{54}]                                                   action => u1
bipush          ::= [\x{10}]                                                   action => u1
caload          ::= [\x{34}]                                                   action => u1
castore         ::= [\x{55}]                                                   action => u1
checkcast       ::= [\x{c0}]                                                   action => u1
d2f             ::= [\x{90}]                                                   action => u1
d2i             ::= [\x{8e}]                                                   action => u1
d2l             ::= [\x{8f}]                                                   action => u1
dadd            ::= [\x{63}]                                                   action => u1
daload          ::= [\x{31}]                                                   action => u1
dastore         ::= [\x{52}]                                                   action => u1
dcmpg           ::= [\x{98}]                                                   action => u1
dcmpl           ::= [\x{97}]                                                   action => u1
dconst_0        ::= [\x{0e}]                                                   action => u1
dconst_1        ::= [\x{0f}]                                                   action => u1
ddiv            ::= [\x{6f}]                                                   action => u1
dload           ::= [\x{18}]                                                   action => u1
dload_0         ::= [\x{26}]                                                   action => u1
dload_1         ::= [\x{27}]                                                   action => u1
dload_2         ::= [\x{28}]                                                   action => u1
dload_3         ::= [\x{29}]                                                   action => u1
dmul            ::= [\x{6b}]                                                   action => u1
dneg            ::= [\x{77}]                                                   action => u1
drem            ::= [\x{73}]                                                   action => u1
dreturn         ::= [\x{af}]                                                   action => u1
dstore          ::= [\x{39}]                                                   action => u1
dstore_0        ::= [\x{47}]                                                   action => u1
dstore_1        ::= [\x{48}]                                                   action => u1
dstore_2        ::= [\x{49}]                                                   action => u1
dstore_3        ::= [\x{4a}]                                                   action => u1
dsub            ::= [\x{67}]                                                   action => u1
dup             ::= [\x{59}]                                                   action => u1
dup_x1          ::= [\x{5a}]                                                   action => u1
dup_x2          ::= [\x{5b}]                                                   action => u1
dup2            ::= [\x{5c}]                                                   action => u1
dup2_x1         ::= [\x{5d}]                                                   action => u1
dup2_x2         ::= [\x{5e}]                                                   action => u1
f2d             ::= [\x{8d}]                                                   action => u1
f2i             ::= [\x{8b}]                                                   action => u1
f2l             ::= [\x{8c}]                                                   action => u1
fadd            ::= [\x{62}]                                                   action => u1
faload          ::= [\x{30}]                                                   action => u1
fastore         ::= [\x{51}]                                                   action => u1
fcmpg           ::= [\x{96}]                                                   action => u1
fcmpl           ::= [\x{95}]                                                   action => u1
fconst_0        ::= [\x{0b}]                                                   action => u1
fconst_1        ::= [\x{0c}]                                                   action => u1
fconst_2        ::= [\x{0d}]                                                   action => u1
fdiv            ::= [\x{6e}]                                                   action => u1
fload           ::= [\x{17}]                                                   action => u1
fload_0         ::= [\x{22}]                                                   action => u1
fload_1         ::= [\x{23}]                                                   action => u1
fload_2         ::= [\x{24}]                                                   action => u1
fload_3         ::= [\x{25}]                                                   action => u1
fmul            ::= [\x{6a}]                                                   action => u1
fneg            ::= [\x{76}]                                                   action => u1
frem            ::= [\x{72}]                                                   action => u1
freturn         ::= [\x{ae}]                                                   action => u1
fstore          ::= [\x{38}]                                                   action => u1
fstore_0        ::= [\x{43}]                                                   action => u1
fstore_1        ::= [\x{44}]                                                   action => u1
fstore_2        ::= [\x{45}]                                                   action => u1
fstore_3        ::= [\x{46}]                                                   action => u1
fsub            ::= [\x{66}]                                                   action => u1
getfield        ::= [\x{b4}]                                                   action => u1
getstatic       ::= [\x{b2}]                                                   action => u1
goto            ::= [\x{a7}]                                                   action => u1
goto_w          ::= [\x{c8}]                                                   action => u1
i2b             ::= [\x{91}]                                                   action => u1
i2c             ::= [\x{92}]                                                   action => u1
i2d             ::= [\x{87}]                                                   action => u1
i2f             ::= [\x{86}]                                                   action => u1
i2l             ::= [\x{85}]                                                   action => u1
i2s             ::= [\x{93}]                                                   action => u1
iadd            ::= [\x{60}]                                                   action => u1
iaload          ::= [\x{2e}]                                                   action => u1
iand            ::= [\x{7e}]                                                   action => u1
iastore         ::= [\x{4f}]                                                   action => u1
iconst_m1       ::= [\x{02}]                                                   action => u1
iconst_0        ::= [\x{03}]                                                   action => u1
iconst_1        ::= [\x{04}]                                                   action => u1
iconst_2        ::= [\x{05}]                                                   action => u1
iconst_3        ::= [\x{06}]                                                   action => u1
iconst_4        ::= [\x{07}]                                                   action => u1
iconst_5        ::= [\x{08}]                                                   action => u1
idiv            ::= [\x{6c}]                                                   action => u1
if_acmpeq       ::= [\x{a5}]                                                   action => u1
if_acmpne       ::= [\x{a6}]                                                   action => u1
if_icmpeq       ::= [\x{9f}]                                                   action => u1
if_icmpne       ::= [\x{a0}]                                                   action => u1
if_icmplt       ::= [\x{a1}]                                                   action => u1
if_icmpge       ::= [\x{a2}]                                                   action => u1
if_icmpgt       ::= [\x{a3}]                                                   action => u1
if_icmple       ::= [\x{a4}]                                                   action => u1
ifeq            ::= [\x{99}]                                                   action => u1
ifne            ::= [\x{9a}]                                                   action => u1
iflt            ::= [\x{9b}]                                                   action => u1
ifge            ::= [\x{9c}]                                                   action => u1
ifgt            ::= [\x{9d}]                                                   action => u1
ifle            ::= [\x{9e}]                                                   action => u1
ifnonnull       ::= [\x{c7}]                                                   action => u1
ifnull          ::= [\x{c6}]                                                   action => u1
iinc            ::= [\x{84}]                                                   action => u1
iload           ::= [\x{15}]                                                   action => u1
iload_0         ::= [\x{1a}]                                                   action => u1
iload_1         ::= [\x{1b}]                                                   action => u1
iload_2         ::= [\x{1c}]                                                   action => u1
iload_3         ::= [\x{1d}]                                                   action => u1
imul            ::= [\x{68}]                                                   action => u1
ineg            ::= [\x{74}]                                                   action => u1
instanceof      ::= [\x{c1}]                                                   action => u1
invokedynamic   ::= [\x{ba}]                                                   action => u1
invokeinterface ::= [\x{b9}]                                                   action => u1
invokespecial   ::= [\x{b7}]                                                   action => u1
invokestatic    ::= [\x{b8}]                                                   action => u1
invokevirtual   ::= [\x{b6}]                                                   action => u1
ior             ::= [\x{80}]                                                   action => u1
irem            ::= [\x{70}]                                                   action => u1
ireturn         ::= [\x{ac}]                                                   action => u1
ishl            ::= [\x{78}]                                                   action => u1
ishr            ::= [\x{7a}]                                                   action => u1
istore          ::= [\x{36}]                                                   action => u1
istore_0        ::= [\x{3b}]                                                   action => u1
istore_1        ::= [\x{3c}]                                                   action => u1
istore_2        ::= [\x{3d}]                                                   action => u1
istore_3        ::= [\x{3e}]                                                   action => u1
isub            ::= [\x{64}]                                                   action => u1
iushr           ::= [\x{7c}]                                                   action => u1
ixor            ::= [\x{82}]                                                   action => u1
jsr             ::= [\x{a8}]                                                   action => u1
jsr_w           ::= [\x{c9}]                                                   action => u1
l2d             ::= [\x{8a}]                                                   action => u1
l2f             ::= [\x{89}]                                                   action => u1
l2i             ::= [\x{88}]                                                   action => u1
ladd            ::= [\x{61}]                                                   action => u1
laload          ::= [\x{2f}]                                                   action => u1
land            ::= [\x{7f}]                                                   action => u1
lastore         ::= [\x{50}]                                                   action => u1
lcmp            ::= [\x{94}]                                                   action => u1
lconst_0        ::= [\x{09}]                                                   action => u1
lconst_1        ::= [\x{0a}]                                                   action => u1
ldc             ::= [\x{12}]                                                   action => u1
ldc_w           ::= [\x{13}]                                                   action => u1
ldc2_w          ::= [\x{14}]                                                   action => u1
ldiv            ::= [\x{6d}]                                                   action => u1
lload           ::= [\x{16}]                                                   action => u1
lload_0         ::= [\x{1e}]                                                   action => u1
lload_1         ::= [\x{1f}]                                                   action => u1
lload_2         ::= [\x{20}]                                                   action => u1
lload_3         ::= [\x{21}]                                                   action => u1
lmul            ::= [\x{69}]                                                   action => u1
lneg            ::= [\x{75}]                                                   action => u1
lookupswitch    ::= [\x{ab}]                                                   action => u1
lor             ::= [\x{81}]                                                   action => u1
lrem            ::= [\x{71}]                                                   action => u1
lreturn         ::= [\x{ad}]                                                   action => u1
lshl            ::= [\x{79}]                                                   action => u1
lshr            ::= [\x{7b}]                                                   action => u1
lstore          ::= [\x{37}]                                                   action => u1
lstore_0        ::= [\x{3f}]                                                   action => u1
lstore_1        ::= [\x{40}]                                                   action => u1
lstore_2        ::= [\x{41}]                                                   action => u1
lstore_3        ::= [\x{42}]                                                   action => u1
lsub            ::= [\x{65}]                                                   action => u1
lushr           ::= [\x{7d}]                                                   action => u1
lxor            ::= [\x{83}]                                                   action => u1
monitorenter    ::= [\x{c2}]                                                   action => u1
monitorexit     ::= [\x{c3}]                                                   action => u1
multianewarray  ::= [\x{c5}]                                                   action => u1
new             ::= [\x{bb}]                                                   action => u1
newarray        ::= [\x{bc}]                                                   action => u1
nop             ::= [\x{00}]                                                   action => u1
pop             ::= [\x{57}]                                                   action => u1
pop2            ::= [\x{58}]                                                   action => u1
putfield        ::= [\x{b5}]                                                   action => u1
putstatic       ::= [\x{b3}]                                                   action => u1
ret             ::= [\x{a9}]                                                   action => u1
return          ::= [\x{b1}]                                                   action => u1
saload          ::= [\x{35}]                                                   action => u1
sastore         ::= [\x{56}]                                                   action => u1
sipush          ::= [\x{11}]                                                   action => u1
swap            ::= [\x{5f}]                                                   action => u1
tableswitch     ::= [\x{aa}]                                                   action => u1
wide            ::= [\x{c4}]                                                   action => u1
