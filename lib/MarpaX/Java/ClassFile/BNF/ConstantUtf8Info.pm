use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantUtf8Info;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_Utf8_info

# VERSION

# AUTHORITY

use Carp qw /croak/;
use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantUtf8Info;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          "'exhausted" => sub { $_[0]->exhausted },
          'u2$'        => sub { $_[0]->lexeme_read_managed($_[0]->literalU2) }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _ConstantUtf8Info {
  my ($self, $length, $managed) = @_;

  my @u1 = defined($managed) ? map { $self->u1($_) } split('', $managed) : [];
  my $value = $self->utf8($managed);
  MarpaX::Java::ClassFile::Struct::ConstantUtf8Info->new(
                                                         tag    => 1,
                                                         length => $length,
                                                         bytes  => \@u1,
                                                         _value => $value
                                                        )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
event 'u2$' = completed u2
ConstantUtf8Info ::=
             u2      # length
             managed # bytes
  action => _ConstantUtf8Info
