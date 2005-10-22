#
# Symbol::Approx::Sub::Text::Metaphone
#
# $Id$
#
# Transformer plugin for Symbol::Approx::Sub;
#
# Copyright (c) 2001, Magnum Solutions Ltd. All rights reserved.
#
# This module is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Log$
# Revision 1.2  2005/10/22 17:56:22  dave
# Added docs.
#
# Revision 1.1  2002/03/29 17:55:40  dave
# Support modules
#
# Revision 1.1  2001/07/15 20:45:25  dave
# Initial revision
#
#
package Symbol::Approx::Sub::Text::Metaphone;

use strict;
use vars qw($VERSION @ISA $AUTOLOAD);

$VERSION = sprintf "%d.%02d", '$Revision$ ' =~ /(\d+)\.(\d+)/;

use Carp;
use Text::Metaphone;

=head1 NAME

Symbol::Approx::Sub::Text::Metaphone

=head1 SYNOPSIS

See L<Symbol::Approx::Sub>

=head1 METHODS

=head2 transform

Returns the array that it is passed with each element converted to its
metaphone equivalent.

=cut

sub transform {
  map { Metaphone($_) } @_;
}

1;
