use Test::More tests => 4;

use_ok('Symbol::Approx::Sub');

sub aa { 'aa' }

sub bb { 'bb' }

ok(a() eq 'aa');

ok(b() eq 'bb');

eval "&c";
ok($@);
