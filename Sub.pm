#
# Symbol::Approx::Sub
#
# $Id$
#
# Perl module for calling subroutines using approximate names.
#
# Copyright (c) 2000, Magnum Solutions Ltd. All rights reserved.
#
# This module is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Log$
# Revision 1.61  2001/06/24 20:04:33  dave
# Version 2 - Release Candidate 1
#
# Revision 1.60  2000/11/17 14:33:14  dave
# Changed name (again!)
# Use Devel::Symdump instead of GlobWalker
#
# Revision 1.50  2000/11/09 21:29:27  dave
# Renamed to Approx::Sub
#
# Revision 1.3  2000/10/30 17:20:07  dave
# Removed all glob-walking code to GlobWalker.pm.
#
# Revision 1.2  2000/10/09 18:52:48  dave
# Incorporated Robin's patches:
# * Don't assume we're being called from main
# * Allow different packages to use different Approx semantics
# * New tests
#
# Revision 1.1  2000/08/24 19:50:18  dave
# Various tidying.
#
#
package Symbol::Approx::Sub;

use strict;
use vars qw($VERSION @ISA $AUTOLOAD);

use Devel::Symdump;

#$VERSION = sprintf "%d.%02d", '$Revision$ ' =~ /(\d+)\.(\d+)/;
$VERSION = '2.00 alpha';

use Carp;

# List of functions that we _never_ try to match approximately.
my @_BARRED = qw(AUTOLOAD BEGIN CHECK INIT DESTROY END);
my %_BARRED = (1) x @_BARRED;

sub _pkg2file {
  $_ = shift;
  s|::|/|g;
  "$_.pm";
}

# import is called when another script uses this module.
# All we do here is overwrite the callers AUTOLOAD subroutine
# with our own.
sub import  {
  my $class = shift;

  no strict 'refs'; # WARNING: Deep magic here!

  my %param;
  my %CONF;
  %param = @_ if @_;

  my %defaults = (canon => 'Text::Soundex',
		  match => 'String::Equal',
		  choose => 'Random');

  # Work out which canonizer(s) to use. The valid options are:
  # 1/ $param{canon} doesn't exist. Use default canoniser.
  # 2/ $param{canon} is undef. Use no canonisers.
  # 3/ $param{canon} is a reference to a subroutine. Use the 
  #    referenced subroutine as the canoniser.
  # 4/ $param{canon} is a scalar. This is the name of a canoniser
  #    module which should be loaded.
  # 5/ $param{canon} is a reference to an array. Each element of the
  #    array is one of the previous two options.

  if (exists $param{canon}) {
    if (defined $param{canon}) {
      my $type = ref $param{canon};
      if ($type eq 'CODE') {
#	if (defined &{$param{canon}}) {
	  $CONF{canon} = [$param{canon}];
#	} else {
#	  croak 'Invalid canoniser passed to Symbol::Approx::Sub';
#	}
      } elsif ($type eq '') {
	my $mod = "Symbol::Approx::Sub::$param{canon}";
	require(_pkg2file($mod));
	$CONF{canon} = [\&{"${mod}::canonise"}];
      } elsif ($type eq 'ARRAY') {
	foreach (@{$param{canon}}) {
	  my $type = ref $_;
	  if ($type eq 'CODE') {
#	    if (defined &{$_}) {
	      push @{$CONF{canon}}, $_;
#	    } else {
#	      croak 'Invalid canoniser passed to Symbol::Approx::Sub';
#	    }
	  } elsif ($type eq '') {
	    my $mod = "Symbol::Approx::Sub::$_";
	    require(_pkg2file($mod));
	    push @{$CONF{canon}}, \&{"${mod}::canonise"};
	  } else {
	    croak 'Invalid canoniser passed to Symbol::Approx::Sub';
	  }
	}
      } else {
	croak 'Invalid canoniser passed to Symbol::Approx::Sub';
      }
    } else {
      $CONF{canon} = [];
    }
  } else {
    my $mod = "Symbol::Approx::Sub::$defaults{canon}";
    require(_pkg2file($mod));
    $CONF{canon} = [\&{"${mod}::canonise"}];
  }

  # Work out which matcher to use. The valid options are:
  # 1/ $param{match} doesn't exist. Use default matcher.
  # 2/ $param{match} is undef. Use no matcher.
  # 3/ $param{match} is a reference to a subroutine. Use the 
  #    referenced subroutine as the matcher.
  # 4/ $param{match} is a scalar. This is the name of a matcher
  #    module which should be loaded.

  if (exists $param{match}) {
    if (defined $param{match}) {
      my $type = ref $param{match};
      if ($type eq 'CODE') {
#	if (defined &{$param{match}}) {
	  $CONF{match} = $param{match};
#	} else {
#	  croak 'Invalid matcher passed to Symbol::Approx::Sub';
#	}
      } elsif ($type eq '') {
	my $mod = "Symbol::Approx::Sub::$param{match}";
	require(_pkg2file($mod));
	$CONF{match} = \&{"${mod}::match"};
      } else {
	croak 'Invalid matcher passed to Symbol::Approx::Sub';
      }
    } else {
      $CONF{match} = undef;
    }
  } else {
    my $mod = "Symbol::Approx::Sub::$defaults{match}";
    require(_pkg2file($mod));
    $CONF{match} = \&{"${mod}::match"};
  }

  # Work out which chooser to use. The valid options are:
  # 1/ $param{choose} doesn't exist. Use default chooser.
  # 2/ $param{choose} is undef. Use default chooser.
  # 3/ $param{choose} is a reference to a subroutine. Use the 
  #    referenced subroutine as the chooser.
  # 4/ $param{choose} is a scalar. This is the name of a chooser
  #    module which should be loaded.

  if (exists $param{choose}) {
    if (defined $param{choose}) {
      my $type = ref $param{choose};
      if ($type eq 'CODE') {
#	if (defined &{$param{chooser}}) {
	  $CONF{chooser} = $param{chooser};
#	} else {
#	  croak 'Invalid chooser passed to Symbol::Approx::Sub';
#	}
      } elsif ($type eq '') {
	my $mod = "Symbol::Approx::Sub::$param{choose}";
	require(_pkg2file($mod));
	$CONF{choose} = \&{"${mod}::choose"};
      } else {
	croak 'Invalid chooser passed to Symbol::Approx::Sub';
      }
    } else {
      my $mod = "Symbol::Approx::Sub::$defaults{choose}";
      require(_pkg2file($mod));
      $CONF{choose} = \&{"4mod::choose"};
    }
  } else {
    my $mod = "Symbol::Approx::Sub::$defaults{choose}";
    require(_pkg2file($mod));
    $CONF{choose} = \&{"${mod}::choose"};
  }

  # Now install appropriate AUTOLOAD routine in caller's package

  my $pkg =  caller(0);
  *{"${pkg}::AUTOLOAD"} = make_AUTOLOAD(%CONF);
}

# Create a subroutine which is called when a given subroutine
# name can't be found in the current package. In the import subroutine
# above we have already arranged that our calling package will use
# the AUTOLOAD created here instead of its own.
sub make_AUTOLOAD {
  my %CONF = @_;

  return sub {
    my @c = caller(0);
    my ($pkg, $sub) = $AUTOLOAD =~ /^(.*)::(.*)$/;

    # Get a list of all of the subroutines in the current package
    # using the get_subs function from GlobWalker.pm
    # Note that we deliberately omit function names that exist
    # in the %_BARRED hash
    my (@subs, @orig);
    my $sym = Devel::Symdump->new($pkg);
    @orig = @subs = grep { ! $_BARRED{$_} } 
                    map { s/${pkg}:://; $_ }
                    grep { defined &{$_} } $sym->functions($pkg);

    unshift @subs, $sub;

    # Canonise all of the subroutine names
    foreach (@{$CONF{canon}}) {
      @subs = $_->(@subs);
    }

    # Call the subroutine that will look for matches
    # The matcher returns a list of the _indexes_ that match
    my @match_ind = $CONF{match}->(@subs);

    shift @subs;

    @subs = @subs[@match_ind];
    @orig = @orig[@match_ind];

    # If we've got more than one matched subroutine, then call the
    # chooser to pick one.
    # Call the matched subroutine using magic goto.
    # If no match was found, die recreating Perl's usual behaviour.
    if (@match_ind) {
      if (@match_ind == 1) {
        $sub = "${pkg}::" . $orig[0];
      } else {
        $sub = "${pkg}::" . $orig[$CONF{choose}->(@subs)];
      }
      goto &$sub;
    } else {
      die "REALLY Undefined subroutine $AUTOLOAD called at $c[1] line $c[2]\n";
    }
  }
}

1;
__END__

=head1 NAME

Symbol::Approx::Sub - Perl module for calling subroutines by approximate names!

=head1 SYNOPSIS

  use Symbol::Approx::Sub;

  sub a {
    # blah...
  }

  &aa; # executes &a if &aa doesn't exist.

  use Symbol::Approx::Sub (match => 'text_metaphone');
  use Symbol::Approx::Sub (match => 'string_approx');
  use Symbol::Approx::Sub (match => 'text_soundex');
  use Symbol::Approx::Sub (match => \&my_matcher);
  use Symbol::Approx::Sub (match => \&my_matcher, choose => \&my_chooser);

=head1 DESCRIPTION

This is _really_ stupid. This module allows you to call subroutines by
_approximate_ names. Why you would ever want to do this is a complete
mystery to me. It was written as an experiment to see how well I
understood typeglobs and AUTOLOADing.

To use it, simply include the line:

  use Symbol::Approx::Sub;

somewhere in your program. Then each time you call a subroutine that doesn't
exist in the the current package Perl will search for a subroutine with
approximately the same name. The meaning of 'approximately the same' is
configurable. The default is to find subroutines with the same Soundex
value (as defined by Text::Soundex) as the missing subroutine. There are
two other built-in matching styles using Text::MetaPhone and 
String::Approx. To use either of these use:

  use Symbol::Approx::Sub (match => 'text_metaphone');

or

  use Symbol::Approx::Sub (match => 'string_approx');

when using Symbol::Approx::Sub.

You can also use your own subroutine to do the matching. Your subroutine
should expect to receive the name of the missing subroutine followed by
a list containing all valid subroutine names and should return a list
containing the _indexes_ of all matching subroutines. For example:

  sub my_matcher {
    my $sub_wanted = shift;

    my @subs = @_;

    return 0 .. $#subs;
}

This example isn't particularly useful as it says that all subroutine
names are an equally good match. To use this match subroutine in place of 
the standard ones, give Symbol::Approx::Sub a reference to the subroutine 
like this:

  use Symbol::Approx::Sub (match => \&my_matcher);

Having retrieved a list of matches, we need to select one of them to
run. The default behaviour is to pick one at random, but again you can
configure this behaviour by writing a subroutine. This subroutine will be
passed a list of matching subroutine names and should return the name of
the subroutine to run. For example:

  sub my_chooser {
    return shift;
  }

which will return the first subroutine name in the list. To make 
Symbol::Approx::Sub use this subroutine in place of the standard one, 
give Symbol::Approx::Sub a reference to the subroutine like this:

  use Symbol::Approx::Sub (choose => \&my_chooser);

You can, of course, define both a matcher and a chooser like this:

  use Symbol::Approx::Sub (match => \&my_matcher, choose => \&my_chooser);

or use you own chooser in conjunction with a standard matcher like this:

  use Symbol::Approx::Sub (match => 'text_metaphone',
                           choose => \&my_chooser);

=head1 CAVEAT

I can't stress too strongly that this will make your code completely 
unmaintainable and you really shouldn't use this module unless you're 
doing something very stupid.

=head1 ACKNOWLEDGEMENTS

This idea came to me whilst sitting in Mark-Jason Dominus' "Tricks of
the Wizards" tutorial. In order to protect his reputation I should
probably point out that just as the idea was forming in my head he
clearly said that this kind of thing was a very bad idea.

Leon Brocard is clearly as mad as me as he pointed out some important bugs
and helped massively with the 'fuzzy-configurability'.

Matt Freake helped by pointing out that Perl generally does what you
mean, not what you think it should do.

Robin Houston spotted some nasty problems and (more importantly) supplied
patches.

=head1 AUTHOR

Dave Cross <dave@dave.org.uk>

With lots of help from Leon Brocard <leon@astray.com>

=head1 SEE ALSO

perl(1).

=cut
