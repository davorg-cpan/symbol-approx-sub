use Test::More;

use Symbol::Approx::Sub;

eval { Symbol::Approx::Sub->import(xform => {}) };
ok($@);

eval { Symbol::Approx::Sub->import(xform => [{}]) };
ok($@);

done_testing;
