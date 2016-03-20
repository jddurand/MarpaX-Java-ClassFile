use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::LocalvarTarget;
use Moo;

# ABSTRACT: Parsing of a supertype_target

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::LocalvarTarget;
require MarpaX::Java::ClassFile::BNF::TableArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"    => sub { $_[0]->exhausted },
                        'table_length$' => sub { $_[0]->inner('TableArray', size => $_[0]->literalU2('table_length')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _LocalvarTarget {
  # my ($self, $table_length, $table) = @_;

  MarpaX::Java::ClassFile::Struct::LocalvarTarget->new(
                                                       table_length => $_[1],
                                                       table        => $_[2]
                                                      )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'table_length$' = completed table_length
localvarTarget ::= table_length table action => _LocalvarTarget
table_length   ::= U2                 action => u2
table          ::= MANAGED            action => ::first
