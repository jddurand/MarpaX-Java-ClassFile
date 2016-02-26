use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Actions;
use Moo::Role;
use Carp qw/croak/;
use Bit::Vector;
use Scalar::Util qw/blessed/;

sub u1 {
  unpack('C', $_[1])
}

sub u2 {
  unpack('n', $_[1])
}

sub u4 { # Bit::Vector for quadratic unpack
  #
  # 33 = 8 * 4 + 1, where +1 to make sure new_Dec never returns a signed value
  #
  my @bytes = split('', $_[1]);
  my $vector = Bit::Vector->new_Dec(33, unpack('C', $bytes[0]));
  foreach (1..3) {
    $vector->Move_Left(8);
    $vector->Or($vector, Bit::Vector->new_Dec(33, unpack('C', $bytes[$_])))
  }
  $vector->to_Dec()
}

sub utf8 {
    my ($self, $bytes) = @_;
    #
    # Disable all conversion warnings:
    # either we know we succeed, either we abort -;
    #
    no warnings;

    my @u1 = split('', $bytes);
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
