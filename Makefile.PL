
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Moose types to check against Moose\'s meta objects',
  'AUTHOR' => 'Florian Ragwitz <rafl@debian.org>',
  'BUILD_REQUIRES' => {
    'Moose::Role' => '0',
    'Moose::Util::TypeConstraints' => '0',
    'MooseX::Role::Parameterized' => '0',
    'MooseX::Types::Moose' => '0',
    'MooseX::Types::Structured' => '0',
    'Test::More' => '0',
    'namespace::autoclean' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'MooseX-Types-Meta',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'MooseX::Types::Meta',
  'PREREQ_PM' => {
    'Carp' => '0',
    'Moose' => '1.05',
    'MooseX::Types' => '0',
    'namespace::clean' => '0'
  },
  'VERSION' => '0.01',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM}; 
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod}; 
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



