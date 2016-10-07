use Test::More;

use_ok('Symbol::Approx::Sub', match => 'String::Approx');

sub aa { 'aa' }

sub test { 'test' }

is(a(), 'aa', 'a() calls aa()');

is(test_it(), 'test', 'test_it() calls test()');

eval { zzz_not_there() };
ok($@, 'Exception thrown');
like($@, qr/^REALLY/, 'Correct exception thrown');

done_testing;
