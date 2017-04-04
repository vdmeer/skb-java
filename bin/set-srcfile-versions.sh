#!/usr/bin/env bash

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
## Sets the @version line in source files
## Call -h for help
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.4.0 build 170404 (04-Apr-17)


## script directory, from https://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
export MOD_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
## script name for error/info messages
export MOD_SCRIPT_NAME=`basename $0`


source $MOD_SCRIPT_DIR/_func_get-system.sh
GetSystem


source $MOD_SCRIPT_DIR/_func_set-directories.sh
SetDirectories


##
## Help screen and exit condition (i.e. too few arguments)
##
Help()
{
	echo ""
	echo "$MOD_SCRIPT_NAME - sets the @version line in source files"
	echo ""
	echo "       Usage:  $MOD_SCRIPT_NAME [-options]"
	echo ""
	echo "       Options"
	echo "         -a         - sets versions in all known projects"
	echo "         -h         - this help screen"
	echo "         -m         - sets versions in master project (skb-java)"
	echo "         -p FOLDER  - sets versions in a particular project"
	echo ""
	exit 0;
}
if [ $# -eq 0 ]; then
	Help
fi


ant="ant -f $_home_sh/src/bundle/pm/set-versions/build.xml -DversionFile=$_home_sh/src/bundle/pm/set-versions/versions.properties"


##
## read command line
##
while [ $# -gt 0 ]
do
	case $1 in
		#-p set versions for project, needs a folder
		-p)
			shift
			if [ ! -d "$1" ]; then
				echo "$MOD_SCRIPT_NAME: given project folder <$1> does not exist?"
				exit 255
			fi
			if [ ! -f "$1/pom.xml" ]; then
				echo "$MOD_SCRIPT_NAME: no POM file found in project folder <$1>"
				exit 255
			fi
			$ant -DmoduleDir=$_home_sh/$1 -DmoduleFile=$_home_sh/$1/src/bundle/pm/project.properties
			shift
		;;

		#-m sets master project versions
		-m)
			shift
			$ant -DmoduleDir=$_home_sh -DmoduleFile=$_home_sh/src/bundle/pm/project.properties -DmacroFile=macro-bin.xml
		;;

		#-a sets versions in all known projects
		-a)
			shift
			projects=`cat src/bundle/pm/projects.pm`
			for dir in $projects
			do
				prj_dir=`echo $dir | sed -e 's/^.*=//'`
				$ant -DmoduleDir=$_home_sh/$prj_dir -DmoduleFile=$_home_sh/$prj_dir/src/bundle/pm/project.properties
			done
		;;

		#-h prints help and exists
		-h)		Help;exit 0;;

		*)	echo "$MOD_SCRIPT_NAME: undefined CLI option - $1"; exit 255;;
	esac
done