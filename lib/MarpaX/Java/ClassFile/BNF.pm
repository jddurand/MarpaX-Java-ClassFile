use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF;
use Moo::Role;
use Data::Section -setup;

my $_bnf_top    = ${__PACKAGE__->section_data('bnf_top')};
my $_bnf_bottom = ${__PACKAGE__->section_data('bnf_bottom')};

#
# Class method
#
sub bnf {
  $_bnf_top . $_[1] . $_bnf_bottom
}

1;

__DATA__
__[ bnf_top ]__
#
# latm is a sane default that can be common to all grammars
#
lexeme default = latm => 1

__[ bnf_bottom ]__
########################################
#           Common rules               #
########################################
u1      ::= U1                 action => u1
u2      ::= U2                 action => u2
u4      ::= U4                 action => u4
managed ::= MANAGED

# ----------------
# Internal Lexemes
# ----------------
_U1      ~ [\s\S]
_U2      ~ _U1 _U1
_U4      ~ _U2 _U2
_MANAGED ~ [^\s\S]

########################################
#          Common lexemes              #
########################################
U1      ~ _U1
U2      ~ _U2
U4      ~ _U4
MANAGED ~ _MANAGED
