#!/bin/bash
#
# Build a set of packages allowing to create a running distribution minimizing the disk space used.
#
# (C) Roberto Di Cosmo 2013
#
# Requires: aspcud-1.7 or later, ceve as of 2013-01-28 or later
#
# Usage: thinnit.sh packages_file payload
#        where 
#
#           - packages_file is the path to a file in Debian Packages format containing
#             the packages available to build the distribution, e.g.
#             /var/lib/apt/lists/ftp.fr.debian.org_debian_dists_testing_main_binary-amd64_Packages
#
#           - payload is a comma-separated list of packages one wants to have on the system, e.g.
#             apache2,php5
#--------------------------------------------------------------------------------------------------

# read the path to the Packages file, like
# /var/lib/apt/lists/ftp.fr.debian.org_debian_dists_testing_main_binary-amd64_Packages
dist=$1

# read the requested packages (optional)
payload=$2

# get the essential, important and required packages
# according to the definitions of a base system, and
# essential packages, found here: 
#   http://www.debian.org/doc/debian-policy/ch-binary.html

needed=`grep-dctrl -F Essential yes < $dist | grep Package | sed 's/Package: //'`","`grep-dctrl -F Priority important < $dist | grep Package | sed 's/Package: //'`","`grep-dctrl -F Priority required < $dist | grep Package | sed 's/Package: //'`
# use , as a separator
needed=`echo $needed | sed 's/ /,/g'`

# catenate payload and needed packages
if [ ".$payload" = "." ]; then 
	request="install: $needed"
else
        request="install: $payload,$needed"
fi
# create CUDF document

ceve -tdeb -Tcudf $dist -o /tmp/instance-$$.cudf --request="$request" 

# compute solution; needs aspcud 1.7 or later

aspcud /tmp/instance-$$.cudf thinned.cudf "-sum(solution,installedsize)"

#check the solution, and make the sum
cudf_sol_check -cudf /tmp/instance-$$.cudf -sol thinned.cudf -crit "-sum(solution,installedsize)"
