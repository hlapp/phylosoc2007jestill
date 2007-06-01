#!/usr/bin/perl -w
#-----------------------------------------------------------+
#                                                           |
# PhyImport.pl - Import data from common file formats       |
#                                                           |
#-----------------------------------------------------------+
#                                                           |
#  AUTHOR: James C. Estill                                  |
# CONTACT: JamesEstill_at_gmail.com                         |
# STARTED: 06/01/2007                                       |
# UPDATED: 06/01/2007                                       |
#                                                           |
# DESCRIPTION:                                              | 
#  Import NEXUS and Newick files from text files to the     |
#  PhyloDB.                                                 | 
#                                                           |
# LICENSE:                                                  |
#  GNU Lesser Public License                                |
#  http://www.gnu.org/licenses/lgpl.html                    |  
#                                                           |
#-----------------------------------------------------------+

=head1 NAME 

PhyInit.pl - Import phylogenetic trees from common file formats

=head1 SYNOPSIS

  Usage: PhyImport.pl
        --dsn        # The DSN string the database to connect to
        --dbuser     # user name to connect with
        --dbpass     # password to connect with
        --dbname     # Name of database to use
        --driver     # "mysql", "Pg", "Oracle" (default "mysql")
        --host       # optional: host to connect with
        --help       # Print this help message
        --quiet      # Run the program in quiet mode.
        --sqldir     # SQL Dir that contains the SQL to create tables
                   

=head1 DESCRIPTION

Import NEXUS and Newick files from text files to the
PhyloDB. 

=head1 ARGUMENTS

=over

=item -d, --dsn

the DSN of the database to connect to; default is the value in the
environment variable DBI_DSN. If DBI_DSN has not been defined and
the string is not passed to the command line, the dsn will be 
constructed from --driver, --dbname, --host

Example: DBI:mysql:database=biosql;host=localhost

=item -u, --dbuser

The user name to connect with; default is the value in the environment
variable DBI_USER.

This user must have permission to add data to tables.

=item -p, --dbpass

password to connect with; default is the value in the environment
variable DBI_PASSWORD. If this is not provided at the command line
the user is prompted.

=item --host

The database host to connect to; default is localhost.

=item --dbname

The database name to connect to; default is biosql.

=item --driver

The database driver to connect with; default is mysql.
Options other then mysql are currently not supported.
    
=item -h, --help

Print the help message.

=item -q, --quiet

Print the program in quiet mode. No output will be printed to STDOUT
and the user will not be prompted for intput.

=back

=head1 AUTHORS

James C. Estill E<lt>JamesEstill at gmail.comE<gt>

Hilmar Lapp, E<lt>hlapp at gmx.netE<gt>

Bill Piel, E<lt>william.piel at yale.eduE<gt>

=cut

#-----------------------------+
# INCLUDES                    |
#-----------------------------+
use strict;
use DBI;
use Getopt::Long;

#-----------------------------+
# VARIABLE SCOPE              |
#-----------------------------+
my $usrname = $ENV{DBI_USER};  # User name to connect to database
my $pass = $ENV{DBI_PASSWORD}; # Password to connect to database
my $dsn = $ENV{DBI_DSN};       # DSN for database connection
my $db;                        # Database name (ie. biosql)
my $host;                      # Database host (ie. localhost)
my $driver;                    # Database driver (ie. mysql)
my $help = 0;                  # Display help
my $sqldir;                    # Directory that contains the sql to run
                               # to create the tables.
my $quiet = 0;                 # Run the program in quiet mode
                               # will not prompt for command line options

#-----------------------------+
# COMMAND LINE OPTIONS        |
#-----------------------------+
my $ok = GetOptions("d|dsn=s"    => \$dsn,
                    "u|dbuser=s" => \$usrname,
                    "p|dbpass=s" => \$pass,
		    "s|sqldir=s" => \$sqldir,
		    "driver=s"   => \$driver,
		    "dbname=s"   => \$db,
		    "host=s"     => \$host,
		    "q|quiet"    => \$quiet,
		    "h|help"     => \$help);




=head1 HISTORY

Started: 05/30/2007

Updated: 06/01/2007

=cut

#-----------------------------------------------------------+
# HISTORY                                                   |
#-----------------------------------------------------------+
# 06/01/2007 - JCE
# - Program started
