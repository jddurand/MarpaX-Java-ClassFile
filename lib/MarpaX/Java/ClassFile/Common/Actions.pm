use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Common::Actions;

# ABSTRACT: Grammar actions role for .class file parsing

# VERSION

# AUTHORITY

use Moo::Role;
#
# This package is part of the core of the engine. So it is optimized
# using directly the stack (i.e. no $self)
#
use Math::BigFloat;
use Carp qw/croak/;
use Bit::Vector;
use Scalar::Util qw/blessed/;
use constant {
  FLOAT_POSITIVE_INF => Math::BigFloat->binf(),
  FLOAT_NEGATIVE_INF => Math::BigFloat->binf('-'),
  FLOAT_NAN => Math::BigFloat->bnan(),
  FLOAT_POSITIVE_ONE => Math::BigFloat->new('1'),
  FLOAT_NEGATIVE_ONE => Math::BigFloat->new('-1'),
};

=head1 DESCRIPTION

MarpaX::Java::ClassFile::Common::Actions is an internal class used by L<MarpaX::Java::ClassFile>, please refer to the later.

=cut

sub u1      { unpack('C', $_[1]) }
sub u2      { unpack('n', $_[1]) }
sub u4      { $_[0]->_quadraToVector($_[1], 1)->to_Dec }  # Ask for an unsigned value explicitely
sub integer { $_[0]->_quadraToVector($_[1],  )->to_Dec }
#
# quadratic: Use Bit::Vector for portability
#
sub _quadraToVector {
  my @u1 = map { $_[0]->u1($_) } split('', $_[1]);
  my $bits = 32;
  #
  # Increase bit numbers by 1 ensure to_Dec() returns the unsigned version
  # Default is to no increase of bit number
  #
  ++$bits if ($_[2]);   # Default is undef
  my $vector = Bit::Vector->new_Dec($bits, $u1[0]);
  $vector->Move_Left(8);
  $vector->Or($vector, Bit::Vector->new_Dec($bits, $u1[1]));
  $vector->Move_Left(8);
  $vector->Or($vector, Bit::Vector->new_Dec($bits, $u1[2]));
  $vector->Move_Left(8);
  $vector->Or($vector, Bit::Vector->new_Dec($bits, $u1[3]));
  $vector
}

my @bitsForFloatCmp =
  (
   Bit::Vector->new_Hex( 32, '7f800000' ),
   Bit::Vector->new_Hex( 32, 'ff800000' ),
   Bit::Vector->new_Hex( 32, '7f800001' ),
   Bit::Vector->new_Hex( 32, '7fffffff' ),
   Bit::Vector->new_Hex( 32, 'ff800001' ),
   Bit::Vector->new_Hex( 32, 'ffffffff' )
  );
my @bitsForFloatMantissa =
  (
   Bit::Vector->new_Hex( 32, 'ff'     ),
   Bit::Vector->new_Hex( 32, '7fffff' ),
   Bit::Vector->new_Hex( 32, '800000' )
  );
my @mathForFloat =
  (
   Math::BigFloat->new('150'),
   Math::BigFloat->new('2'),
  );

sub floatToString { $_[0]->double($_[1], $_[2])->bstr() }
sub float {
  my $vector = $_[0]->_quadraToVector($_[1]);

  my $value;
  if ($vector->equal($bitsForFloatCmp[0])) {
    $value = FLOAT_POSITIVE_INF->copy
  }
  elsif ($vector->equal( $bitsForFloatCmp[1])) {
    $value = FLOAT_NEGATIVE_INF->copy
  }
  elsif (
         (
          $vector->Lexicompare( $bitsForFloatCmp[2] ) >= 0  &&
          $vector->Lexicompare( $bitsForFloatCmp[3] ) <= 0
         )
         ||
         (
          $vector->Lexicompare( $bitsForFloatCmp[4] ) >= 0 &&
          $vector->Lexicompare( $bitsForFloatCmp[5] ) <= 0
         )
        ) {
    $value = FLOAT_NAN->copy
  }
  else {
    #
    # int s = ((bits >> 31) == 0) ? 1 : -1;
    #
    my $s = $vector->Clone();
    $s->Move_Right(31);
    my $sf = ($s->to_Dec() == 0) ? FLOAT_POSITIVE_ONE->copy() : FLOAT_NEGATIVE_ONE->copy();
    #
    # int e = ((bits >> 23) & 0xff);
    #
    my $e = $vector->Clone();
    $e->Move_Right(23);
    $e->And( $e, $bitsForFloatMantissa[0] );
    #
    # int m = (e == 0) ? (bits & 0x7fffff) << 1 : (bits & 0x7fffff) | 0x800000;
    #                     ^^^^^^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^^^^^^^^^
    #                                       \       /
    #                                        \     /
    #                                      same things
    #
    my $m = $vector->Clone();
    $m->And( $m, $bitsForFloatMantissa[1] );
    if ( $e->to_Dec() == 0 ) {
      $m->Move_Left(1);
    } else {
      $m->Or( $m, $bitsForFloatMantissa[2] );
    }
    #
    # $value = $s * $m * (2 ** ($e - 150))
    # Note: Bit::Vector->to_Dec() returns a string
    my $mf = Math::BigFloat->new($m->to_Dec());
    my $ef = Math::BigFloat->new($e->to_Dec());

    $ef->bsub($mathForFloat[0]);              # $e - 150
    my $mantissaf = $mathForFloat[1]->copy(); # 2
    $mantissaf->bpow($ef);                    # 2 ** ($e - 150)
    $mf->bmul($mantissaf);                    # $m * (2 ** ($e - 150))
    $mf->bmul($sf);                           # $s * $m * (2 ** ($e - 150))
    $value = $mf
  }

  $value
}

sub long {
  my $vhigh = $_[0]->_quadraToVector($_[1]);
  my $vlow  = $_[0]->_quadraToVector($_[2]);
  #
  # ((long) high_bytes << 32) + low_bytes
  #
  Bit::Vector->Concat_List($vhigh, $vlow)->to_Dec()
}

my @bitsForDoubleCmp = (
                       Bit::Vector->new_Hex( 64, "7ff0000000000000" ),
                       Bit::Vector->new_Hex( 64, "fff0000000000000" ),
                       Bit::Vector->new_Hex( 64, "7ff0000000000001" ),
                       Bit::Vector->new_Hex( 64, "7fffffffffffffff" ),
                       Bit::Vector->new_Hex( 64, "fff0000000000001" ),
                       Bit::Vector->new_Hex( 64, "ffffffffffffffff" )
                      );
my @bitsForDoubleMantissa =
  (
   Bit::Vector->new_Hex( 64, '7ff'           ),
   Bit::Vector->new_Hex( 64, 'fffffffffffff' ),
   Bit::Vector->new_Hex( 64, '10000000000000' )
  );
my @mathForDouble =
  (
   Math::BigFloat->new('1075'),
   Math::BigFloat->new('2'),
  );

sub doubleToString { $_[0]->double($_[1], $_[2])->bstr() }
sub double {
  my $vhigh = $_[0]->_quadraToVector($_[1]);
  my $vlow  = $_[0]->_quadraToVector($_[2]);
  #
  # ((long) high_bytes << 32) + low_bytes
  #
  my $vector = Bit::Vector->Concat_List($vhigh, $vlow);
  #
  # Same technique as in float
  #
  my $value;
  if ($vector->equal($bitsForDoubleCmp[0])) {
    $value = FLOAT_POSITIVE_INF->copy
  }
  elsif ($vector->equal( $bitsForDoubleCmp[1])) {
    $value = FLOAT_NEGATIVE_INF->copy
  }
  elsif (
         (
          $vector->Lexicompare( $bitsForDoubleCmp[2] ) >= 0  &&
          $vector->Lexicompare( $bitsForDoubleCmp[3] ) <= 0
         )
         ||
         (
          $vector->Lexicompare( $bitsForDoubleCmp[4] ) >= 0 &&
          $vector->Lexicompare( $bitsForDoubleCmp[5] ) <= 0
         )
        ) {
    $value = FLOAT_NAN->copy
  }
  else {
    #
    # int s = ((bits >> 63) == 0) ? 1 : -1;
    #
    my $s = $vector->Clone();
    $s->Move_Right(63);
    my $sf = ($s->to_Dec() == 0) ? FLOAT_POSITIVE_ONE->copy() : FLOAT_NEGATIVE_ONE->copy();
    #
    # int e = (int)((bits >> 52) & 0x7ffL);
    #
    my $e = $vector->Clone();
    $e->Move_Right(52);
    $e->And( $e, $bitsForDoubleMantissa[0] );
    #
    # long m = (e == 0) ? (bits & 0xfffffffffffffL) << 1 : (bits & 0xfffffffffffffL) | 0x10000000000000L;
    #                     ^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^^^^^^^^^^^^^^^^^^^^
    #                                             \       /
    #                                              \     /
    #                                            same things
    my $m = $vector->Clone();
    $m->And( $m, $bitsForDoubleMantissa[1] );
    if ( $e->to_Dec() == 0 ) {
      $m->Move_Left(1);
    } else {
      $m->Or( $m, $bitsForDoubleMantissa[2] );
    }
    #
    # $value = $s * $m * (2 ** ($e - 1075))
    #
    my $mf = Math::BigFloat->new($m->to_Dec());
    my $ef = Math::BigFloat->new($e->to_Dec());

    $ef->bsub($mathForDouble[0]);              # $e - 1075
    my $mantissaf = $mathForDouble[1]->copy(); # 2
    $mantissaf->bpow($ef);                     # 2 ** ($e - 150)
    $mf->bmul($mantissaf);                     # $m * (2 ** ($e - 150))
    $mf->bmul($sf);                            # $s * $m * (2 ** ($e - 150))
    $value = $mf;
  }

  $value
}

sub utf8 {
    #
    # Disable all conversion warnings:
    # either we know we succeed, either we abort -;
    #
    no warnings;

    my @u1 = split('', $_[1]);
    my $s     = '';

    while (@u1) {
        my @val;

        $val[0] = unpack( 'C', $u1[0] );
        if ( $val[0] == 0 || ( ( $val[0] >= 0xF0 ) && ( $val[0] <= 0xFF ) ) )
        {
            croak "Invalid byte with value $val[0]: " . Dumper( $u1[0] );
        }
        #
        # Below x means either 0 or 1
        #
        # 6 bytes ?
        #
        if ( $val[0] == 0xED ) {    # 0xED == 11101101
            if ( $#u1 >= 1 ) {
                $val[1] = unpack( 'C', $u1[1] );
                if ( $val[1] == 0 || ( $val[1] >= 0xF0 && $val[1] <= 0xFF ) )
                {
                    croak "Invalid byte with value $val[1]";
                }
                if ( ( $val[1] & 0xF0 ) == 0xA0 )
                {                   # 0xF0 == 11110000, 0xA0 == 10100000
                    if ( $#u1 >= 2 ) {
                        $val[2] = unpack( 'C', $u1[2] );
                        if ( $val[2] == 0
                            || ( $val[2] >= 0xF0 && $val[2] <= 0xFF ) )
                        {
                            croak "Invalid byte with value $val[2]";
                        }
                        if ( ( $val[2] & 0xC0 ) == 0x80 )
                        {           # 0xC0 == 11000000, 0x80 == 10000000
                            if ( $#u1 >= 3 ) {
                                $val[3] = unpack( 'C', $u1[3] );
                                if ( $val[3] == 0
                                    || ( $val[3] >= 0xF0 && $val[3] <= 0xFF )
                                    )
                                {
                                    croak "Invalid byte with value $val[3]";
                                }
                                if ( $val[3] == 0xED ) {    # 0xED == 11101101
                                    if ( $#u1 >= 4 ) {
                                        $val[4] = unpack( 'C', $u1[4] );
                                        if ($val[4] == 0
                                            || (   $val[4] >= 0xF0
                                                && $val[4] <= 0xFF )
                                            )
                                        {
                                            croak
                                                "Invalid byte with value $val[4]";
                                        }
                                        if ( ( $val[4] & 0xF0 ) == 0xB0 )
                                        { # 0xF0 == 11110000, 0xA0 == 10110000
                                            if ( $#u1 >= 5 ) {
                                                $val[5]
                                                    = unpack( 'C', $u1[5] );
                                                if ($val[5] == 0
                                                    || (   $val[5] >= 0xF0
                                                        && $val[5] <= 0xFF )
                                                    )
                                                {
                                                    croak
                                                        "Invalid byte with value $val[2]";
                                                }
                                                if ( ( $val[5] & 0xC0 )
                                                    == 0x80 )
                                                { # 0xC0 == 11000000, 0x80 == 10000000
                                                        #
                                                     # 11101101 1010xxxx 10xxxxxx 11101101 1011xxxx 10xxxxxx: code points above U+FFFF
                                                     #
                                                    $s .= chr(
                                                        0x10000 + (
                                                            (   $val[1] & 0x0F
                                                            ) << 16
                                                            ) + (
                                                            (   $val[2] & 0x3F
                                                            ) << 10
                                                            ) + (
                                                            (   $val[4] & 0x0F
                                                            ) << 6
                                                            ) + (
                                                            $val[5] & 0x3F
                                                            )
                                                    );
                                                    shift(@u1);
                                                    shift(@u1);
                                                    shift(@u1);
                                                    shift(@u1);
                                                    shift(@u1);
                                                    shift(@u1);
                                                    next;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        #
        # 3 bytes ?
        #
        if ( ( $val[0] & 0xF0 ) == 0xE0 )
        {    # 0xF0 == 11110000, 0xE0 == 11100000
            if ( $#u1 >= 1 ) {
                $val[1] = unpack( 'C', $u1[1] );
                if ( $val[1] == 0 || ( $val[1] >= 0xF0 && $val[1] <= 0xFF ) )
                {
                    croak "Invalid byte with value $val[1]";
                }
                if ( ( $val[1] & 0xC0 ) == 0x80 )
                {    # 0xC0 == 11000000, 0x80 == 10000000
                    if ( $#u1 >= 2 ) {
                        $val[2] = unpack( 'C', $u1[2] );
                        if ( $val[2] == 0
                            || ( $val[2] >= 0xF0 && $val[2] <= 0xFF ) )
                        {
                            croak "Invalid byte with value $val[2]";
                        }
                        if ( ( $val[2] & 0xC0 ) == 0x80 )
                        {    # 0xC0 == 11000000, 0x80 == 10000000
                                #
                             # 1110xxxx 10xxxxxx 10xxxxxx: Code points in the range '\u0800' to '\uFFFF'
                             #
                            $s
                                .= chr( ( ( $val[0] & 0xF ) << 12 )
                                + ( ( $val[1] & 0x3F ) << 6 )
                                    + ( $val[2] & 0x3F ) );
                            shift(@u1);
                            shift(@u1);
                            shift(@u1);
                            next;
                        }
                    }
                }
            }
        }
        #
        # 2 bytes ?
        #
        if ( ( $val[0] & 0xE0 ) == 0xC0 )
        {    # 0xE0 == 11100000, 0xC0 == 11000000
            if ( $#u1 >= 1 ) {
                $val[1] = unpack( 'C', $u1[1] );
                if ( $val[1] == 0 || ( $val[1] >= 0xF0 && $val[1] <= 0xFF ) )
                {
                    croak "Invalid byte with value $val[1]";
                }
                if ( ( $val[1] & 0xC0 ) == 0x80 )
                {    # 0xC0 == 11000000, 0x80 == 10000000
                        #
                     # 110xxxxx 10xxxxxx: null code point ('\u0000') and code points in the range '\u0080' to '\u07FF'
                     #
                    $s .= chr(
                        ( ( $val[0] & 0x1F ) << 6 ) + ( $val[1] & 0x3F ) );
                    shift(@u1);
                    shift(@u1);
                    next;
                }
            }
        }
        #
        # 1 byte ?
        #
        if ( ( $val[0] & 0x80 ) == 0 ) {
            #
            # 0xxxxxxx: Code points in the range '\u0001' to '\u007F'
            #
            $s .= chr( $val[0] );
            shift(@u1);
            next;
        }
        croak "Unable to map byte with value " . sprintf( '0x%x', $val[0] );
    }

    return $s;
}

1;
