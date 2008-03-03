use Test::More tests => 2;

use Symbol::Approx::Sub;

eval { Symbol::Approx::Sub->import(xform => {}) };
ok($@);

eval { Symbol::Approx::Sub->import(xform => [{}]) };
ok($@);
