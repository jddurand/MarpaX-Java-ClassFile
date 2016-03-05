use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Validator;
use Moo;
use MooX::Role::Logger;
use Types::Standard -all;

# ABSTRACT: Java .class files validation

# VERSION

# AUTHORITY

my %_ACCESSFLAGS =
  (
   ACC_PUBLIC     => [ 0x0001, 'public'     ],
   ACC_FINAL      => [ 0x0010, 'final'      ],
   ACC_SUPER      => [ 0x0020, 'super'      ],
   ACC_INTERFACE  => [ 0x0200, 'interface'  ],
   ACC_ABSTRACT   => [ 0x0400, 'abstract'   ],
   ACC_SYNTHETIC  => [ 0x1000, 'synthetic'  ],
   ACC_ANNOTATION => [ 0x2000, 'annotation' ],
   ACC_ENUM       => [ 0x4000, 'enum'       ]
);

=head1 DESCRIPTION

MarpaX::Java::ClassFile::Validator is validating .class files.

=cut

has classFiles  => ( is => 'ro', isa => HashRef[InstanceOf['MarpaX::Java::ClassFile']], default => sub { [] } );

sub validate {
  my ($self) = @_;

  foreach (@{$self->classFiles}) {
    $self->_validateClassFile($_);
  }

  $self
}

sub _validateClassFile {
  my ($self, $classFile) = @_;

  $self->_validateClassFileAccessFlags($classFile);
}

sub _validateClassFileAccessFlags {
  my ($self, $classFile) = @_;

  my $accessFlags = $classFile->accessFlags;
  my @accessFlags = ();

  my $allbits = 0;
  my %hasFlag = ();
  foreach (keys %_ACCESSFLAGS) {
    my ($mask, $value) = @{$_ACCESSFLAGS{$_}};
    $hasFlag{$_} = (($accessFlags2 & $mask) == $mask) ? 1 : 0;
    push(@accessFlags, $value) if ($hasFlag{$_});
    $allbits |= $mask;
  }
  #
  # Check what the spec says about access flags contraints
  #
  if ($hasFlag{ACC_INTERFACE}) {
    #
    # If the ACC_INTERFACE flag is set, the ACC_ABSTRACT flag must also be set,
    # and the ACC_FINAL, ACC_SUPER, and ACC_ENUM flags set must not be set.
    #
    $self->_logger->errorf('ACC_ABSTRACT flag must be set') unless ($hasFlag{ACC_ABSTRACT});
    $self->_logger->errorf('ACC_FINAL flag must not be set')    if ($hasFlag{ACC_FINAL});
    $self->_logger->errorf('ACC_SUPER flag must not be set')    if ($hasFlag{ACC_SUPER});
    $self->_logger->errorf('ACC_ENUM flag must not be set')     if ($hasFlag{ACC_ENUM});
  } else {
    #
    # If the ACC_INTERFACE flag is not set, any of the other flags in (...) may be set
    # except ACC_ANNOTATION.
    #
    $self->_logger->errorf('ACC_ANNOTATION flag must not be set') if ($hasFlag{ACC_ANNOTATION});
    #
    # However, such a class file must not have both its ACC_FINAL and ACC_ABSTRACT flags set
    #
    $self->_logger->errorf('ACC_FINAL and ACC_ABSTRACT flags must not be both set') if ($hasFlag{ACC_FINAL} && $hasFlag{ACC_ABSTRACT});
  }
  #
  # If the ACC_ANNOTATION flag is set, the ACC_INTERFACE flag must also be set.
  #
  $self->_logger->errorf('ACC_INTERFACE flag must be set') if ($hasFlag{ACC_ANNOTATION} && ! $hasFlag{ACC_INTERFACE});
}

sub _thisClass {
  my ($self, $u2) = @_;

  my $thisClass = undef;
  #
  # The value of the this_class item must be a valid index into the constant_pool table.
  #
  my $constantPoolArray = $self->constantPoolArray;
  if ($u2 > scalar(@{$constantPoolArray})) {
    $self->warnf('this_class item must be a valid index into the constant_pool table, got %d > %d', $u2, scalar(@{$constantPoolArray}))
  } else {
    my $constantPoolItem = $constantPoolArray->[$u2 - 1];
    #
    # The constant_pool entry at that index must be a CONSTANT_Class_info structure (...)
    # representing the class or interface defined by this class file.
    #
    my $blessed = blessed($constantPoolItem) // '';
    if ($blessed ne 'CONSTANT_Class_info') {
      $self->warnf('The constant_pool entry at index %d must be a CONSTANT_Class_info structure, got %s', $u2, $blessed)
    } else {
      my $name_index = $constantPoolItem->{name_index};
      $thisClass = $constantPoolArray->[$name_index - 1]->{computed_value};
    }
  }

  $thisClass
}

1;
