use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ParmaeterArray;
use Moo;

# ABSTRACT: Parsing of an array of parameter

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::Parameter;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"        => sub { $_[0]->exhausted },
                        'parameter$'        => sub { $_[0]->inc_nbDone },
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _Parameter {
  # my ($self, $name_index, $access_flags) = @_;

  MarpaX::Java::ClassFile::Struct::Parameter->new(
                                                  name_index   => $_[1],
                                                  access_flags => $_[2]
                                                 )
}

with 'MarpaX::Java::ClassFile::Role::Parser::InnerGrammar';

1;

__DATA__
__[ bnf ]__
event 'parameter$' = completed parameter
:default          ::= action => [values]
ParameterArray    ::= parameter*
parameter         ::= name_index access_flags action => _BootstrapMethod
name_index        ::= U2                      action => u2
access_flags      ::= U2                      action => u2
