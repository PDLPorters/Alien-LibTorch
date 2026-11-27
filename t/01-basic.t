use strict;
use warnings;
use Test::More;
use Test::Alien;
use Alien::LibTorch;

alien_ok 'Alien::LibTorch';

like(Alien::LibTorch->cflags, qr/-I/, 'cflags includes -I path');
like(Alien::LibTorch->libs,   qr/-ltorch/, 'libs includes -ltorch');

done_testing();
