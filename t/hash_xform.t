use Test::More;

use Symbol::Approx::Sub;

eval { Symbol::Approx::Sub->import(xform => {}) };
like($@, qr/^Invalid/, 'An empty hash ref is an invalid xformer');

eval { Symbol::Approx::Sub->import(xform => [{}]) };
like($@, qr/^Invalid/, 'An array of empty hash refs is an invalid xformer');

done_testing;
