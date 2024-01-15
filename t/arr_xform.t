use strict;
use warnings;
use Test::More;

use Symbol::Approx::Sub (xform => [ sub { map { s/[^a-z]//rig } @_ },
                                    sub { map { lc } @_ } ]);


sub a_a { 'aa' }

is(AA(), 'aa', 'AA() calls a_a()');

done_testing;
