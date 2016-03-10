use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::SourceFileAttribute;
use Moo;

# ABSTRACT: Parsing of a SourceFile_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::SourceFileAttribute;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"        => sub { $_[0]->exhausted }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _SourceFile_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $sourcefile_index) = @_;

  MarpaX::Java::ClassFile::Struct::SourceFileAttribute->new(
                                                            attribute_name_index => $_[1],
                                                            attribute_length     => $_[2],
                                                            sourcefile_index     => $_[3]
                                                           )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
SourceFile_attribute ::= attribute_name_index attribute_length sourcefile_index action => _SourceFile_attribute
attribute_name_index ::= U2                                                     action => u2
attribute_length     ::= U4                                                     action => u4
sourcefile_index     ::= U2                                                     action => u2
