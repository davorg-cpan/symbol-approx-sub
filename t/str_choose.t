# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::Simple tests => 1;

use Symbol::Approx::Sub (choose => 'String::Equal');


sub aa { 'aa' }

ok(&a eq 'aa');
