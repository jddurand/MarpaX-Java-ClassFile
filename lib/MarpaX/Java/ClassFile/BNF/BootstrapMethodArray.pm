use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::BootstrapMethodArray;
use Moo;

# ABSTRACT: Parsing of an array of bootstrap method

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::BootstrapMethod;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"               => sub { $_[0]->exhausted },
                        'bootstrap_method$'        => sub { $_[0]->inc_nbDone },
                        'num_bootstrap_arguments$' => sub {
                          my $num_bootstrap_arguments = $_[0]->literalU2('num_bootstrap_arguments');
                          map { $_[0]->lexeme_read_u2(1) } (1..$num_bootstrap_arguments); # Ignore events
                          $_[0]->lexeme_read_managed(0)                                  # Will trigger completion event
                        }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _BootstrapMethod {
  # my ($self, $bootstrap_method_ref, $num_bootstrap_arguments, $bootstrap_arguments) = @_;

  MarpaX::Java::ClassFile::Struct::BootstrapMethod->new(
                                                        _constant_pool          => $_[0]->constant_pool,
                                                        bootstrap_method_ref    => $_[1],
                                                        num_bootstrap_arguments => $_[2],
                                                        bootstrap_arguments     => $_[3]
                                                       )
}

with 'MarpaX::Java::ClassFile::Role::Parser::InnerGrammar';

1;

__DATA__
__[ bnf ]__
event 'bootstrap_method$' = completed bootstrap_method
event 'num_bootstrap_arguments$' = completed num_bootstrap_arguments
:default                ::= action => [values]
BootstrapMethodArray    ::= bootstrap_method*
bootstrap_method        ::= bootstrap_method_ref num_bootstrap_arguments bootstrap_arguments (end) action => _BootstrapMethod
bootstrap_method_ref    ::= U2                                                        action => u2
num_bootstrap_arguments ::= U2                                                        action => u2
bootstrap_arguments     ::= bootstrap_argument*                                       action => [values]
bootstrap_argument      ::= U2                                                        action => u2
end                     ::= MANAGED                                                   # Used to trigger the completion event
