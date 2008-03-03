use Test::More tests => 1;

use Symbol::Approx::Sub (xform => undef,
			 match => sub { shift; 
					for (0 .. $#_) {
					  return $_ if $_[$_] eq 'aa'
					}
					return });

sub aa { 'aa' }

sub bb { 'bb' }

ok(&b eq 'aa');
