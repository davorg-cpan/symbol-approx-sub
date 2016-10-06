use Test::More tests => 1;

use Symbol::Approx::Sub (xform => 'Text::Soundex');


sub a_a { 'aa' }

ok(aa() eq 'aa');
