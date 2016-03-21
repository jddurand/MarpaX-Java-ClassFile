use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Util::AccessFlagsStringification;
use Exporter 'import'; # gives you Exporter's import() method directly
our @EXPORT_OK = qw/accessFlagsStringificator/;

# ABSTRACT: Returns the string describing access flags

# VERSION

# AUTHORITY

my @_ACCESS_FLAG = (
                    [ ACC_PUBLIC     => 0x0001 ],
                    [ ACC_FINAL      => 0x0010 ],
                    [ ACC_SUPER      => 0x0020 ],
                    [ ACC_INTERFACE  => 0x0200 ],
                    [ ACC_ABSTRACT   => 0x0400 ],
                    [ ACC_SYNTHETIC  => 0x1000 ],
                    [ ACC_ANNOTATION => 0x2000 ],
                    [ ACC_ENUM       => 0x4000 ],
);


sub accessFlagsStringificator {
  # my ($self, $access_flags) = @_;

  join(', ', map { $_ACCESS_FLAG[$_]->[0] } grep { ($_[1] & $_ACCESS_FLAG[$_]->[1]) == $_ACCESS_FLAG[$_]->[1] } (0..$#_ACCESS_FLAG))
}

1;
