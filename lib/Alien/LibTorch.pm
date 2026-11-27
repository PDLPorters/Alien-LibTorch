package Alien::LibTorch;

use 5.010;
use strict;
use warnings;
use parent qw(Alien::Base);

our $VERSION = '0.001';

1;

__END__

=head1 NAME

Alien::LibTorch - Find or download the PyTorch C++ (LibTorch) library

=head1 SYNOPSIS

    use ExtUtils::MakeMaker;
    use Alien::Base::Wrapper ();

    WriteMakefile(
        Alien::Base::Wrapper->new('Alien::LibTorch')->mm_args2(
            NAME => 'PDL::ML::Engine::Torch',
        ),
    );

=head1 DESCRIPTION

This distribution provides the PyTorch C++ (C<libtorch>) tensor library so that
it can be used by other Perl and L<PDL> distributions. If C<libtorch> is
already installed on the system (via C<$ENV{LIBTORCH_DIR}>, system paths, or
Homebrew on macOS), C<Alien::LibTorch> uses the system installation; otherwise
it downloads the official prebuilt CPU C<libtorch> archive for the current
platform.

=head1 METHODS

Inherits all methods from L<Alien::Base>, including C<cflags>, C<libs>,
C<dynamic_libs>, and C<version>.

=head1 TUTORIAL

=head2 Consuming Alien::LibTorch in an XS Distribution

Use L<Alien::Base::Wrapper> in your F<Makefile.PL> to automatically inject the
include paths (C<cflags>) and linker flags (C<libs>, including C<-ltorch>,
C<-ltorch_cpu>, C<-lc10>, and C<-Wl,-rpath> on Unix) required to compile and
link against C<libtorch>. Because C<libtorch> exposes a C++17 API, configure
your build to use a C++17 compiler:

    use strict;
    use warnings;
    use ExtUtils::MakeMaker;
    use Alien::Base::Wrapper ();

    WriteMakefile(
        Alien::Base::Wrapper->new('Alien::LibTorch')->mm_args2(
            NAME         => 'PDL::ML::Engine::Torch',
            VERSION_FROM => 'lib/PDL/ML/Engine/Torch.pm',
            CC           => 'g++',
            LD           => 'g++',
            CCFLAGS      => '-std=c++17',
            CONFIGURE_REQUIRES => {
                'Alien::Base::Wrapper' => '0',
                'Alien::LibTorch'      => '0.001',
                'ExtUtils::MakeMaker'  => '6.52',
            },
        ),
    );

In your XS/C++ code, include C<E<lt>torch/torch.hE<gt>>:

    #include <torch/torch.h>

=head2 Using Alien::LibTorch with FFI::Platypus

C<Alien::LibTorch> installs shared libraries (C<libtorch>, C<libtorch_cpu>,
C<libc10>). You can pass C<dynamic_libs> to L<FFI::Platypus> when binding to
C-ABI entry points or a thin C wrapper library linked against C<libtorch>:

    use strict;
    use warnings;
    use FFI::Platypus 2.00;
    use Alien::LibTorch;

    my $ffi = FFI::Platypus->new(
        api => 2,
        lib => [ Alien::LibTorch->dynamic_libs ],
    );

=head2 Controlling System vs. Share Installation

During installation, C<Alien::LibTorch> probes for an existing installation in
the following order:

=over 4

=item 1. C<$ENV{LIBTORCH_DIR}> (if set)

=item 2. C<brew --prefix pytorch> on macOS (C<darwin>)

=item 3. F</usr/local> and F</usr>

=back

If no system installation is found, it downloads the official prebuilt CPU
C<libtorch> archive for the current platform (Linux, macOS arm64, or Windows).

You can override this behaviour with C<ALIEN_INSTALL_TYPE>:

=over 4

=item * B<Force a system install> (optionally pointing to a custom prefix with C<LIBTORCH_DIR>):

    # Linux / macOS
    LIBTORCH_DIR=/opt/libtorch ALIEN_INSTALL_TYPE=system cpanm Alien::LibTorch

    # Windows (PowerShell)
    $env:LIBTORCH_DIR = 'C:\libtorch'
    $env:ALIEN_INSTALL_TYPE = 'system'
    cpanm Alien::LibTorch

=item * B<Force a share install> (always download the prebuilt CPU C<libtorch> archive):

    # Linux / macOS
    ALIEN_INSTALL_TYPE=share cpanm Alien::LibTorch

    # Windows (PowerShell)
    $env:ALIEN_INSTALL_TYPE = 'share'; cpanm Alien::LibTorch

=back

=head2 Inspecting the Installation

See F<examples/check_alien.pl> in this distribution for a runnable script that
prints C<install_type>, C<version>, C<cflags>, C<libs>, and C<dynamic_libs>.

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2026 Google LLC

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
