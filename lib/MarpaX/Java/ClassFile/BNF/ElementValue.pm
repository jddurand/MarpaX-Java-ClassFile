use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ElementValue;
use Moo;

# ABSTRACT: Parsing of a element_value

# VERSION

# AUTHORITY

#
# Note: this union is easy, no need to subclass the BNFs
#

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ElementValue;
use MarpaX::Java::ClassFile::BNF::ConstValueIndex;
use MarpaX::Java::ClassFile::BNF::EnumConstValue;
use MarpaX::Java::ClassFile::BNF::ClassInfoIndex;
use MarpaX::Java::ClassFile::BNF::Annotation;
use MarpaX::Java::ClassFile::BNF::ArrayValue;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"  => sub { $_[0]->exhausted },
                        'tag$'        => sub {
                          my $tag = $_[0]->literalU1('tag');
                          if    ($tag == ord('B')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('C')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('D')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('F')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('I')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('J')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('S')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('Z')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('s')) { $_[0]->inner('ConstValueIndex') }
                          elsif ($tag == ord('e')) { $_[0]->inner('EnumConstValue') }
                          elsif ($tag == ord('c')) { $_[0]->inner('ClassInfoIndex') }
                          elsif ($tag == ord('@')) { $_[0]->inner('Annotation') }
                          elsif ($tag == ord('[')) { $_[0]->inner('ArrayValue') }
                          else                { $_[0]->fatalf('Unmanaged element value tag %d', $tag) }
                        }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _ElementValue {
  # my ($self, $tag, $value) = @_;

  MarpaX::Java::ClassFile::Struct::ElementValue->new(
                                                     tag   => $_[1],
                                                     value => $_[2]
                                                    )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'tag$' = completed tag
ElementValue ::= tag managed action => _ElementValue
tag          ::= U1          action => u1
managed      ::= MANAGED     action => ::first
