use Test::More;

use Symbol::Approx::Sub;

eval { Symbol::Approx::Sub->import(xform => {}) };
like($@, qr/^Invalid/);

eval { Symbol::Approx::Sub->import(xform => [{}]) };
like($@, qr/^Invalid/);

done_testing;
