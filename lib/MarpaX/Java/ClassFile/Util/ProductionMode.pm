use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Util::ProductionMode;

# ABSTRACT: Provide an prod_isa that, in production mode, returns nothing

# VERSION

# AUTHORITY

use Exporter 'import';
our @EXPORT_OK = qw/prod_isa/;

sub prod_isa { $ENV{AUTHOR_TESTING} ? (isa => @_) : () }

1;
