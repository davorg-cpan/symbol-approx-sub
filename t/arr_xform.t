use Test::More;

use Symbol::Approx::Sub (xform => [ sub { map { s/[^a-z]//ig; $_ } @_ },
                                    sub { map { lc } @_ } ]);


sub a_a { 'aa' }

is(AA(), 'aa');

done_testing;
