use Test::More;

require Symbol::Approx::Sub;

note('Hashref transformer');
eval {
  Symbol::Approx::Sub->import(xform => {});
};

ok($@, 'Got an exception');
like($@, qr/^Invalid transformer/, 'Got the right exception');

note('Hashref transformer in an arrayref');
eval {
  Symbol::Approx::Sub->import(xform => [{}]);
};

ok($@, 'Got an exception');
like($@, qr/^Invalid transformer/, 'Got the right exception');

note('Hashref matcher');
eval {
  Symbol::Approx::Sub->import(match => {});
};

ok($@, 'Got an exception');
like($@, qr/^Invalid matcher/, 'Got the right exception');

note('Arrayref matcher');
eval {
  Symbol::Approx::Sub->import(match => []);
};

ok($@, 'Got an exception');
like($@, qr/^Invalid matcher/, 'Got the right exception');

note('Hashref chooser');
eval {
  Symbol::Approx::Sub->import(choose => {});
};

ok($@, 'Got an exception');
like($@, qr/^Invalid chooser/, 'Got the right exception');

note('Arrayref chooser');
eval {
  Symbol::Approx::Sub->import(choose => []);
};

ok($@, 'Got an exception');
like($@, qr/^Invalid chooser/, 'Got the right exception');
done_testing;
