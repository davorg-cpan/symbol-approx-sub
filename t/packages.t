use Test::More tests => 3;

package x;

use Symbol::Approx::Sub (xform => 'Text::Soundex'); 
Test::More::ok(bar() eq 'yep');
sub baar {'yep'}
sub qux  {12}

package y;
use Symbol::Approx::Sub (canon => undef,
			 match => sub {shift; return 0 .. $#_});
Test::More::ok(x()::quux()==12);
Test::More::ok(y()::quux()==23);

sub flurble {23}
