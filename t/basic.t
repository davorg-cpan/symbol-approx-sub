use Test::More;

use_ok('Symbol::Approx::Sub');

sub aa { 'aa' }

sub bb { 'bb' }

is(a(), 'aa');

is(b(), 'bb');

eval { c() };
ok($@);

done_testing;
