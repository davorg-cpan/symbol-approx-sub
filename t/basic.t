use Test::More;

use_ok('Symbol::Approx::Sub');

sub aa { 'aa' }

sub bb { 'bb' }

is(a(), 'aa', 'a() calls aa()');

is(b(), 'bb', 'b() calls bb()');

eval { c() };
like($@, qr/^REALLY/);

done_testing;
