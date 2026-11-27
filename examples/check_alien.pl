#!/usr/bin/env perl
# Copyright 2026 Google LLC

use strict;
use warnings;
require Alien::LibTorch;

my $install_type = Alien::LibTorch->install_type // 'unknown';
my $version      = Alien::LibTorch->version      // 'unknown';
my $cflags       = Alien::LibTorch->cflags       // '';
my $libs         = Alien::LibTorch->libs         // '';
my @dynamic_libs = Alien::LibTorch->dynamic_libs;

print 'Alien::LibTorch installation details:', "\n";
print '  install_type : ', $install_type, "\n";
print '  version      : ', $version,      "\n";
print '  cflags       : ', $cflags,       "\n";
print '  libs         : ', $libs,         "\n";
print '  dynamic_libs : ', (@dynamic_libs ? join(', ', @dynamic_libs) : '(none)'), "\n";
