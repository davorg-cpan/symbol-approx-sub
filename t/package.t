# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

package x;

use Test::Simple tests => 1;

use Symbol::Approx::Sub (xform => undef,
			 match => sub { my ($sub, @subs) = @_;
					foreach (0 .. $#subs) {
					  return $_
					    if $sub eq reverse $subs[$_];
					}
					return;});

sub oof {'yep'};

ok(foo() eq 'yep');
