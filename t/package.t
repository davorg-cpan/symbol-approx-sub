package x;

use Test::More tests => 1;

use Symbol::Approx::Sub (xform => undef,
			 match => sub { my ($sub, @subs) = @_;
					foreach (0 .. $#subs) {
					  return $_
					    if $sub eq reverse $subs[$_];
					}
					return;});

sub oof {'yep'};

ok(foo() eq 'yep');
