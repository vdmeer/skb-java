#!/bin/bash

## Copyright 2016 Sven van der Meer <vdmeer.sven@mykolab.com>
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##

##
## Sets file versions for a particular project using given version properties.
## Call
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)


##
## Get system, need this information for creating build scripts
## taken from: https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux#3466183 - see there for details
##
GetSystem()
{
	case "$(uname -s)" in
		Darwin)
			echo 'found Mac OS X'
			system=MAC
			;;
		Linux)
			echo 'Linux'
			system=LINUX
			;;
		CYGWIN*)
			echo 'found Cygwin'
			system=CYGWIN
			;;
		MINGW32*|MSYS*)
			echo 'found MS Windows'
			system=WINDOWS
			;;
		*)
			echo 'found other OS'
			system="???" 
			;;
	esac
}


##
## Sets directories for specific systems (call GetSystem first)
##
SetDirectories()
{
	home_abs=`pwd`

	CP=${LIB_HOME}/*
	SCRIPT_NAME=`basename $0`

	echo "set directories: $system"
	if [ "$system" == "CYGWIN" ] ; then
		if [[ $home_abs == *"/cygdrive"* ]]; then
			home_sh="/"`echo $home_abs | cut -d/ -f4-`
		else
			home_sh=${home_abs}
		fi
	else
		home_sh=${home_abs}
	fi
}


GetSystem
SetDirectories

ant="ant -f src/bundle/pm/set-versions/build.xml -DversionFile=$home_sh/src/bundle/pm/set-versions/versions.properties"

projects=`cat src/bundle/pm/projects.pm`
for dir in $projects
do
	prj_dir=`echo $dir | sed -e 's/^.*=//'`
	$ant -DmoduleDir=$home_sh/$prj_dir -DmoduleFile=$home_sh/$prj_dir/src/bundle/pm/project.properties
done
