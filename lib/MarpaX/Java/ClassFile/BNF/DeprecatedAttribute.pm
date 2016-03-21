use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::DeprecatedAttribute;
use Moo;

# ABSTRACT: Parsing of an deprecated attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::DeprecatedAttribute;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          "'exhausted" => sub { $_[0]->exhausted }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _DeprecatedAttribute {
  # my ($self, $U1, $U4, $MANAGED) = @_;

  MarpaX::Java::ClassFile::Struct::DeprecatedAttribute->new(
                                                            _constant_pool       => $_[0]->constant_pool,
                                                            attribute_name_index => $_[1],
                                                            attribute_length     => $_[2]
                                                          )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
DeprecatedAttribute ::= attribute_name_index attribute_length action => _DeprecatedAttribute
attribute_name_index ::= U2      action => u2
attribute_length     ::= U4      action => u4
