# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::Simple tests => 1;

use Symbol::Approx::Sub (xform => undef,
			 match => sub { shift; 
					for (0 .. $#_) {
					  return $_ if $_[$_] eq 'aa'
					}
					return });

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

sub aa { 'aa' }

sub bb { 'bb' }

ok(&b eq 'aa');
