use Test::More;

use Symbol::Approx::Sub (xform => [ 'Text::Soundex' ]);


sub a_a { 'aa' }

is(aa(), 'aa');

done_testing();
