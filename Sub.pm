#
# Sub::Approx
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
package Sub::Approx;

use strict;
use vars qw($VERSION @ISA $AUTOLOAD);

use GlobWalker qw(get_subs);

$VERSION = sprintf "%d.%02d", '$Revision$ ' =~ /(\d+)\.(\d+)/;

use Carp;

# List of functions that we _never_ try to match approximately.
my %_BARRED = { AUTOLOAD => 1, 
		DESTROY => 1,
		END => 1 };

# import is called when another script uses this module.
# All we do here is overwrite the callers AUTOLOAD subroutine
# with our own.
sub import  {
  my $class = shift;

  my %CONF;
  %CONF = @_ if @_;
  my $default = 'text_soundex';

  # Subroutines called to handle our built-in matchers.
  my %funcs = (text_soundex => [\&setup_text_soundex,
				\&match_text_soundex],
	       text_metaphone => [\&setup_text_metaphone,
				  \&match_text_metaphone],
	       string_approx => [\&setup_string_approx,
				 \&match_string_approx]);

  # Work out which matcher subroutine to use. There are four valid options:
  # 1/ $CONF{match} is empty - use default matcher (&match_text_soundex)
  # 2/ $CONF{match} is a code ref to an existing subroutine use the 
  #                 referenced subroutine
  # 3/ $CONF{match} is a scalar - use one of the predefined matchers
  # and three invalid ooptions:
  # 1/ $CONF{match} is a scalar that doesn't match the predefined matchers
  # 2/ $CONF{match} is some other kind of reference.
  # 3/ $CONF{match} is a reference to an undefined subroutine

  if (exists $CONF{match}) {
    if (ref $CONF{match} eq 'CODE') {
      croak 'Invalid matcher passed to Sub::Approx' 
	unless defined &{$CONF{match}};
    } elsif (ref $CONF{match} eq '') {
      if (exists $funcs{$CONF{match}}) {
	$funcs{$CONF{match}}->[0]->();
	$CONF{match} = $funcs{$CONF{match}}->[1];
      } else {
	croak 'Invalid matcher passed to Sub::Approx';
      }
    } else {
      croak 'Invalid matcher passed to Sub::Approx';
    }
  } else {
    $funcs{$default}->[0]->();
    # Run the setup routine for the predefined matcher.
    $CONF{match} = $funcs{$default}->[1];
  }

  # Work out which chooser to use. $CONF{choose} is either non-existant
  # or a reference to the subroutine to use.
  if (exists $CONF{choose}) {
    if (ref $CONF{choose} ne 'CODE') {
      croak 'Invalid chooser passed to Sub::Approx';
    }
    croak 'Invalid chooser passed to Sub::Approx' 
      unless defined &{$CONF{choose}};
  } else {
    $CONF{choose} = \&choose;
  }

  # Now install appropriate AUTOLOAD routine in caller's package

  no strict 'refs'; # WARNING: Deep magic here!
  my $pkg =  caller(0);
  *{"${pkg}::AUTOLOAD"} = make_AUTOLOAD(%CONF);
}

#
# The next three subroutines are used to set up the default matchers.
# Only one of these will ever get called.
# Notice that we 'require' and 'import' rather than 'use' the modules
# because 'use' happens at compile time and all of the modules would
# be loaded into memory.
sub setup_text_soundex {
  require Text::Soundex;
  Text::Soundex->import;
}

sub setup_text_metaphone {
  require Text::Metaphone;
  Text::Metaphone->import;
}

sub setup_string_approx {
  require String::Approx;
  String::Approx->import('amatch');
}

#
# The next three subroutines are the predefined matcher routines.
# Each of them takes as arguments the name of the missing subroutine
# and a list of all of the subroutines in the current package. The
# matcher subroutine returns a list of subroutine names which match
# the missing subroutine's name.
sub match_text_soundex {
  my ($wantsub, @subs) = @_;
  my %cache;

  # For each subroutine name, we work out the equivalent soundex value
  # and store it in the cache hash. Actually we store a list of
  # subroutine names against each soundex value.
  foreach my $sub (@subs) {
    push @{$cache{soundex($sub)}}, $sub;
  }

  # Now work out the soundex value for the subroutine that has been called
  $wantsub = soundex($wantsub);
  
  return @{$cache{$wantsub}} if (exists $cache{$wantsub});
  return;
}

sub match_text_metaphone {
  my ($wantsub, @subs) = @_;

  my %cache;

  # For each subroutine name, we work out the equivalent metaphone value
  # and store it in the cache hash. Actually we store a list of
  # subroutine names against each metaphone value.
  foreach my $sub (@subs) {
    push @{$cache{Metaphone($sub)}}, $sub;
  }

  # Now work out the metaphone value for the subroutine that has been called
  $wantsub = Metaphone($wantsub);
  
  return @{$cache{$wantsub}} if (exists $cache{$wantsub});
  return;
}
  
sub match_string_approx {
  my ($wantsub, @subs) = @_;

  # Luckily, the author of String::Approx makes this
  # really easy 
  return amatch($wantsub, @subs);
}

#
# The default chooser subroutine.
# This subroutine is passed a list of subroutines which match the
# name of the missing subroutine (this list was created by the
# matcher subroutine. The chooser subroutine must return one of
# the names from this list.
sub choose {
  $_[rand @_];
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
    my @subs = grep { ! $_BARRED{$_} } get_subs($pkg);
  
    # Call the subroutine that will look for matches
    my @matches = $CONF{match}->($sub, @subs);
  
    # See if a subroutine (or subroutines) exist with the same soundex value.
    # If so, pick one using the 'choose' subroutine to call and call it
    # using magic goto.
    # If not, die recreating Perl's usual behaviour.
    if (@matches) {
      $sub = "${pkg}::" . $CONF{choose}->(@matches);
      goto &$sub;
    } else {
      die "REALLY Undefined subroutine $AUTOLOAD called at $c[1] line $c[2]\n";
    }
  }
}

1;
__END__

=head1 NAME

Sub::Approx - Perl module for calling subroutines by approximate names!

=head1 SYNOPSIS

  use Sub::Approx;
  
  sub a {
    # blah...
  }

  &aa; # executes &a if &aa doesn't exist.

  use Sub::Approx (match => 'text_metaphone');
  use Sub::Approx (match => 'string_approx');
  use Sub::Approx (match => 'text_soundex');
  use Sub::Approx (match => \&my_matcher);
  use Sub::Approx (match => \&my_matcher, choose => \&my_chooser);

=head1 DESCRIPTION

This is _really_ stupid. This module allows you to call subroutines by
_approximate_ names. Why you would ever want to do this is a complete
mystery to me. It was written as an experiment to see how well I 
understood typeglobs and AUTOLOADing.

To use it, simply include the line:

  use Sub::Approx;

somewhere in your program. Then each time you call a subroutine that doesn't
exist in the the current package Perl will search for a subroutine with
approximately the same name. The meaning of 'approximately the same' is
configurable. The default is to find subroutines with the same Soundex
value (as defined by Text::Soundex) as the missing subroutine. There are
two other built-in matching styles using Text::MetaPhone and 
String::Approx. To use either of these use:

  use Sub::Approx (match => 'text_metaphone');

or

  use Sub::Approx (match => 'string_approx');

when using Sub::Approx.

You can also use your own subroutine to do the matching. Your subroutine
should expect to receive the name of the missing subroutine followed by
a list containing all valid subroutine names and should return a list
of all matching subroutines. For example:

  sub my_matcher {
    my $sub_wanted = shift;

    my @subs = @_;

    return @subs;
}

This example isn't particularly useful as it says that all subroutine
names are an equally good match. To use this match subroutine in place of 
the standard ones, give Sub::Approx a reference to the subroutine like this:

  use Sub::Approx (match => \&my_matcher);

Having retrieved a list of matches, we need to select one of them to
run. The default behaviour is to pick one at random, but again you can
configure this behaviour by writing a subroutine. This subroutine will be
passed a list of matching subroutine names and should return the name of
the subroutine to run. For example:

  sub my_chooser {
    return shift;
  }

which will return the first subroutine name in the list. To make Sub::Approx
use this subroutine in place of the standard one, give Sub::Approx a
reference to the subroutine like this:

  use Sub::Approx (choose => \&my_chooser);

You can, of course, define both a matcher and a chooser like this:

  use Sub::Approx (match => \&my_matcher, choose => \&my_chooser);

or use you own chooser in conjunction with a standard matcher like this:

  use Sub::Approx (match => 'text_metaphone',
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
