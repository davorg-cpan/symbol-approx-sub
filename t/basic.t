# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::Simple tests => 4;

END {print "not ok 1\n" unless $loaded;}
use Symbol::Approx::Sub;
$loaded = 1;
ok($loaded);

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

sub aa { 'aa' }

sub bb { 'bb' }

ok(&a eq 'aa');

ok(&b eq 'bb');

eval "&c";
ok($@);
