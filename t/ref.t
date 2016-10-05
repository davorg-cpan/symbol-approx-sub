use Test::More tests => 1;

use Symbol::Approx::Sub(xform => undef,
			match => \always_bb());

sub always_bb {
  my ($sub, @subs) = @_;

  foreach (0 .. $#subs) {
    return $_ if $subs[$_] eq 'bb';
  }

  return;
}

sub aa { 'aa' }

sub bb { 'bb' }

ok(a() eq 'bb');
