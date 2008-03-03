#
# Symbol::Approx::Sub::String::Approx
#
# $Id$
#
# Matcher plugin for Symbol::Approx::Sub;
#
# Copyright (c) 2000, Magnum Solutions Ltd. All rights reserved.
#
# This module is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Log$
# Revision 1.2  2005/10/22 17:56:22  dave
# Added docs.
#
# Revision 1.1  2002/03/29 17:55:31  dave
# Support modules
#
# Revision 1.1  2001/07/15 20:42:26  dave
# Initial revision
#
#
package Symbol::Approx::Sub::String::Approx;

use strict;
use vars qw($VERSION @ISA $AUTOLOAD);

$VERSION = sprintf "%d", '$Revision$ ' =~ /(\d+)/;

use Carp;
use String::Approx 'amatch';

=head1 NAME

Symbol::Approx::Sub::String::Approx

=head1 SYNOPSIS

See L<Symbol::Approx::Sub>

=head1 METHODS

=head2 match

Passed a value and a list of values. Returns the values from  the list
which match the initial value using the C<amatch> method from
L<String::Approx>.

=cut

sub match {
  my ($sub, @subs) = @_;
  my (@ret);

  foreach (0 .. $#subs) {
    push @ret, $_ if amatch($sub, $subs[$_]);
  }

  @ret;
}

1;
