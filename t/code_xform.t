use strict;
use warnings;
use Test::More;

use Symbol::Approx::Sub (xform => sub { map { s/[^A-Za-z]//rg } @_ });

sub a_a { 'aa' }

is(aa(), 'aa', 'aa() calls a_a()');

done_testing;
