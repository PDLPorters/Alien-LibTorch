# Alien-LibTorch

`Alien::LibTorch` finds or downloads the PyTorch C++ (`libtorch`) tensor library so that it can be consumed by Perl and `PDL` distributions (including `PDL::ML` backends).

If `libtorch` is already installed on your system (via `$ENV{LIBTORCH_DIR}`, Homebrew on macOS, `/usr/local`, or `/usr`), `Alien::LibTorch` uses the system installation; otherwise it downloads the official prebuilt CPU `libtorch` archive (v2.6.0) for Linux, macOS arm64, or Windows.

## Installation

### Default (auto-detect system, fall back to share download)

```sh
cpanm Alien::LibTorch
```

### System vs. Share Install

Control whether `Alien::LibTorch` uses a system installation or downloads the prebuilt archive via `ALIEN_INSTALL_TYPE`:

- **Linux / macOS**:
  ```sh
  LIBTORCH_DIR=/opt/libtorch ALIEN_INSTALL_TYPE=system cpanm Alien::LibTorch
  ALIEN_INSTALL_TYPE=share cpanm Alien::LibTorch
  ```
- **Windows (PowerShell)**:
  ```powershell
  $env:LIBTORCH_DIR = 'C:\libtorch'; $env:ALIEN_INSTALL_TYPE = 'system'; cpanm Alien::LibTorch
  $env:ALIEN_INSTALL_TYPE = 'share'; cpanm Alien::LibTorch
  ```

#### Installing `libtorch` as a System Package

- **Debian / Ubuntu (`apt`)**:
  ```sh
  sudo apt-get update && sudo apt-get install -y libtorch-dev
  ```
- **macOS (`brew`)**:
  ```sh
  brew install pytorch
  ```
  `Alien::LibTorch` automatically probes `brew --prefix pytorch` on macOS.
- **Windows (`vcpkg`)**:
  ```powershell
  vcpkg install libtorch
  # Set LIBTORCH_DIR to your vcpkg installed prefix, or use ALIEN_INSTALL_TYPE=share.
  ```

## Usage

### XS (`Makefile.PL` with `Alien::Base::Wrapper`)

```perl
use ExtUtils::MakeMaker;
use Alien::Base::Wrapper ();

WriteMakefile(
    Alien::Base::Wrapper->new('Alien::LibTorch')->mm_args2(
        NAME    => 'PDL::ML::Engine::Torch',
        CC      => 'g++',
        LD      => 'g++',
        CCFLAGS => '-std=c++17',
    ),
);
```

### FFI (`FFI::Platypus`)

```perl
use FFI::Platypus 2.00;
use Alien::LibTorch;

my $ffi = FFI::Platypus->new(
    api => 2,
    lib => [ Alien::LibTorch->dynamic_libs ],
);
```

## Inspecting Your Installation

Run the bundled inspection script:

```sh
perl examples/check_alien.pl
```

## Documentation

For complete documentation and tutorials, see the POD:

```sh
perldoc Alien::LibTorch
```
