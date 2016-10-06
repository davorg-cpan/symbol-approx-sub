use Test::More;

use Symbol::Approx::Sub (xform => sub { map { s/[^A-Za-z]//g; $_ } @_ });

sub a_a { 'aa' }

is(aa(), 'aa');

done_testing;
