use Test::More;

use_ok('Symbol::Approx::Sub', match => 'String::Approx');

sub aa { 'aa' }

sub bb { 'bb' }

is(a(), 'aa', 'a() calls aa()');

is(b(), 'bb', 'b() calls bb()');

eval { c() };
ok($@, 'Exception thrown');
like($@, qr/^REALLY/, 'Correct exception thrown');

done_testing;
