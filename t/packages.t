# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::Simple tests => 3;

package x;

use Symbol::Approx::Sub (xform => 'Text::Soundex'); 
Test::Simple::ok(bar() eq 'yep');
sub baar {'yep'}
sub qux  {12}

package y;
use Symbol::Approx::Sub (canon => undef,
			 match => sub {shift; return 0 .. $#_});
Test::Simple::ok(&x::quux()==12);
Test::Simple::ok(&y::quux()==23);

sub flurble {23}
