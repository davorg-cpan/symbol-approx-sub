# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::Simple tests => 2;

use Symbol::Approx::Sub;

eval { Symbol::Approx::Sub->import(xform => {}) };
ok($@);

eval { Symbol::Approx::Sub->import(xform => [{}]) };
ok($@);
