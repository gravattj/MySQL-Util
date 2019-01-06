MySQL-Util

[![Build Status](https://travis-ci.org/gravattj/MySQL-Util.svg?branch=master)](https://travis-ci.org/gravattj/MySQL-Util)

DESCRIPTION
    Utility functions for working with MySQL.

REQUIRES

    Modules:
    --------
    DBD::mysql
    namespace::autoclean
    Moose
    Test::More

    Database:
    ---------
    A running instance of mysql.  See CONF file for connection configuration.


INSTALLATION

To install this module, run the following commands:

    modify CONF file as appropriate

	perl Makefile.PL
	make
	make test
	make install

SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc MySQL::Util

You can also look for information at:

    RT, CPAN's request tracker
        http://rt.cpan.org/NoAuth/Bugs.html?Dist=MySQL-Util

    AnnoCPAN, Annotated CPAN documentation
        http://annocpan.org/dist/MySQL-Util

    CPAN Ratings
        http://cpanratings.perl.org/d/MySQL-Util

    Search CPAN
        http://search.cpan.org/dist/MySQL-Util/


LICENSE AND COPYRIGHT

Copyright (C) 2011 John Gravatt

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

...
