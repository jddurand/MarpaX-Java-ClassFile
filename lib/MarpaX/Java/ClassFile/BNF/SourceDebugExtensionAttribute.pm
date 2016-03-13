use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SourceDebugExtensionAttribute;
use Moo;

# ABSTRACT: Parsing of a SourceDebugExtension_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::SourceDebugExtensionAttribute;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"        => sub { $_[0]->exhausted },
                        'attribute_length$' => sub {
                          my $attribute_length = $_[0]->literalU4('attribute_length');
                          map { $_[0]->lexeme_read_u1(1) } (1..$attribute_length);
                          lexeme_read_managed(0)
                        }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _SourceDebugExtension_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $debug_extension) = @_;

  MarpaX::Java::ClassFile::Struct::SourceDebugExtensionAttribute->new(
                                                            attribute_name_index => $_[1],
                                                            attribute_length     => $_[2],
                                                            debug_extension      => $_[3]
                                                           )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'attribute_length$' = completed attribute_length
SourceDebugExtension_attribute ::= attribute_name_index attribute_length debug_extension (end) action => _SourceDebugExtension_attribute
attribute_name_index ::= U2                                                     action => u2
attribute_length     ::= U4                                                     action => u4
debug_extension      ::= debug                                                  action => [values]
debug                ::= U2                                                     action => u2
end                  ::= MANAGED                                                # Used to trigger the exhaustion event
