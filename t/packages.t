use Test::More;

package Foo;

use Symbol::Approx::Sub (xform => 'Text::Soundex'); 
Test::More::is(bar(), 'yep');
sub baar {'yep'}
sub qux  {12}

package Bar;
use Symbol::Approx::Sub (xform => undef,
			 match => sub {shift; return 0 .. $#_});
Test::More::is(Foo::quux(), 12);
Test::More::is(Bar::quux(), 23);

sub flurble {23}

package main;

done_testing;
