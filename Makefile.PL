use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use Alien::Build::MM;

my $abmm = Alien::Build::MM->new;

WriteMakefile($abmm->mm_args(
    NAME               => 'Alien::LibTorch',
    DISTNAME           => 'Alien-LibTorch',
    AUTHOR             => q{C.J. Collier <cjac@google.com>},
    VERSION_FROM       => 'lib/Alien/LibTorch.pm',
    ABSTRACT_FROM      => 'lib/Alien/LibTorch.pm',
    LICENSE            => 'perl_5',
    MIN_PERL_VERSION   => '5.010',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.52',
        'Alien::Build::MM'    => '0.32',
    },
    BUILD_REQUIRES => {
        'Alien::Build::MM' => '0.32',
    },
    TEST_REQUIRES => {
        'Test::More'  => '0.88',
        'Test::Alien' => '0',
    },
    PREREQ_PM => {
        'Alien::Base' => '0.038',
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'https://github.com/PDLPorters/Alien-LibTorch.git',
                web  => 'https://github.com/PDLPorters/Alien-LibTorch',
            },
            bugtracker => {
                web => 'https://github.com/PDLPorters/Alien-LibTorch/issues',
            },
        },
    },
    clean => { FILES => 'Alien-LibTorch-* _alien' },
));

sub MY::postamble {
    $abmm->mm_postamble;
}
