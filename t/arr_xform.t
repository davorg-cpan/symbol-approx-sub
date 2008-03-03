use Test::Simple tests => 1;

use Symbol::Approx::Sub (xform => [ sub { map { s/[^a-z]//ig; $_ } @_ },
                                    sub { map { lc } @_ } ]);


sub a_a { 'aa' }

ok(&AA eq 'aa');
