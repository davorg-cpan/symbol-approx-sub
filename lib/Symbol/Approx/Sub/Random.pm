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
# Revision 1.1  2002/03/29 17:55:25  dave
# Support modules
#
# Revision 1.1  2001/07/15 20:41:01  dave
# Initial revision
#
#
package Symbol::Approx::Sub::Random;

use strict;
use vars qw($VERSION @ISA $AUTOLOAD);

$VERSION = sprintf "%d.%02d", '$Revision$ ' =~ /(\d+)\.(\d+)/;

use Carp;

sub choose {
  rand @_;
}

1;
