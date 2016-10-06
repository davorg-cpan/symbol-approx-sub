use Test::More tests => 1;

use Symbol::Approx::Sub (xform => sub { map { s/[^A-Za-z]//g; $_ } @_ });

sub a_a { 'aa' }

ok(aa() eq 'aa');
