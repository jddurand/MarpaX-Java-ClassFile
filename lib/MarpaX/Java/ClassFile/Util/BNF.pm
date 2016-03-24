use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Util::BNF;

# ABSTRACT: Provides common BNF top and header contents

# VERSION

# AUTHORITY

use Data::Section -setup;
use Exporter 'import';

our @EXPORT_OK = qw/bnf/;
our %EXPORT_TAGS = (all => \@EXPORT_OK);

my $_bnf_top    = ${__PACKAGE__->section_data('bnf_top')};
my $_bnf_bottom = ${__PACKAGE__->section_data('bnf_bottom')};

#
# Class method
#
sub bnf {
  my ($class, $bnf, $top, $bottom) = @_;
  join('', $top // $_bnf_top, $bnf, $bottom // $_bnf_bottom)
}

1;

__DATA__
__[ bnf_top ]__
#
# latm is a sane default that can be common to all grammars
#
lexeme default = latm => 1
#
# This is more dangerous, but let's say we know what we are doing.
#
inaccessible is ok by default

__[ bnf_bottom ]__
###################################################
# Prevent Marpa saying that a lexeme is unreachable
# External BNF's are not supposed to use these
###################################################
u1_internal      ::= U1
u2_internal      ::= U2
u4_internal      ::= U4
managed_internal ::= MANAGED

########################################
#          Common lexemes              #
########################################
_U1      ~ [\s\S]
_U2      ~ _U1 _U1
_U4      ~ _U2 _U2
_MANAGED ~ [^\s\S]

U1      ~ _U1
U2      ~ _U2
U4      ~ _U4
MANAGED ~ _MANAGED
