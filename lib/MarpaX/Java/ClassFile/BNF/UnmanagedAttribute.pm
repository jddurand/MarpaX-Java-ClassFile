use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::UnmanagedAttribute;
use Moo;

# ABSTRACT: Parsing of an unmanaged attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::UnmanagedAttribute;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          "'exhausted" => sub { $_[0]->exhausted },
          'U4$'        => sub { $_[0]->lexeme_read_managed($_[0]->pauseU4) }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _UnmanagedAttribute {
  # my ($self, $U1, $U4, $MANAGED) = @_;

  MarpaX::Java::ClassFile::Struct::UnmanagedAttribute->new(
                                                           attribute_name_index => $_[1],
                                                           attribute_length => $_[2],
                                                           info  => $_[3]
                                                          )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
:lexeme ~ <U4> pause => after event => 'U4$'

UnmanagedAttribute ::=
             attribute_name_index
             attribute_length
             info
  action => _UnmanagedAttribute

attribute_name_index ::= U2      action => u2
attribute_length     ::= U4      action => u4
info                 ::= MANAGED action => ::first
