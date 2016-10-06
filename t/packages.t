use Test::More;

package x;

use Symbol::Approx::Sub (xform => 'Text::Soundex'); 
Test::More::is(bar(), 'yep');
sub baar {'yep'}
sub qux  {12}

package y;
use Symbol::Approx::Sub (canon => undef,
			 match => sub {shift; return 0 .. $#_});
Test::More::is(x::quux(), 12);
Test::More::is(y::quux(), 23);

sub flurble {23}

package main;

done_testing;
