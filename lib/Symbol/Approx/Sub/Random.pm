#
# Symbol::Approx::Sub::String::Equal
#
# $Id$
#
# Chooser plugin for Symbol::Approx::Sub;
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
# Revision 1.1  2002/03/29 17:55:25  dave
# Support modules
#
# Revision 1.1  2001/07/15 20:41:01  dave
# Initial revision
#
#
package Symbol::Approx::Sub::Random;

require 5.006_000;
use strict;
use warnings;

our ($VERSION, @ISA, $AUTOLOAD);

$VERSION = '2.07';

use Carp;

=head1 NAME

Symbol::Approx::Sub::Random

=head1 SYNOPSIS

See L<Symbol::Approx::Sub>

=head1 METHODS

=head2 choose

Returns a random index into the array which it is passed.

=cut

sub choose {
  rand @_;
}

1;
