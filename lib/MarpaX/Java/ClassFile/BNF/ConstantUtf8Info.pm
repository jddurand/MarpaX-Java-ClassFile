use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantUtf8Info;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_Utf8_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ConstantUtf8Info;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          "'exhausted" => sub { $_[0]->exhausted },
          'U2$'        => sub { $_[0]->lexeme_read_managed($_[0]->pauseU2) }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _ConstantUtf8Info {
  # my ($self, $U1, $U2, $MANAGED) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantUtf8Info->new(
                                                         tag    => $_[0]->u1($_[1]),
                                                         length => $_[0]->u2($_[2]),
                                                         bytes  => $_[3],
                                                         _value => $_[0]->utf8($_[3])
                                                        )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
:lexeme ~ <U2> pause => after event => 'U2$'

ConstantUtf8Info ::=
             [\x{01}] # tag
             U2       # length
             MANAGED  # bytes
  action => _ConstantUtf8Info
