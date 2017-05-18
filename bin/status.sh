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
## Simply goes to a repository and prints short or long status information
## Call -h for help
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.4.0 build 170404 (04-Apr-17)


## script directory, from https://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
##                        https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
export MOD_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
## script name for error/info messages
MOD_SCRIPT_NAME=`basename $0`

source $MOD_SCRIPT_DIR/_func_set-projects.sh
SetProjects



## do short git status
do_short=false


##
## Help screen and exit condition (i.e. too few arguments)
##
Help()
{
	echo ""
	echo "$MOD_SCRIPT_NAME - shows status information of repositories"
	echo ""
	echo "       Usage:  $MOD_SCRIPT_NAME [-options]"
	echo ""
	echo "       Options"
	echo "         -a          - run status on all kown project"
	echo "         -h          - this help screen"
	echo "         -p FOLDER   - project to build as a folder relative from the current directory"
	echo "         -s          - short information, e.g. git status -s"
	echo ""
	exit 255;
}
if [ $# -eq 0 ]; then
	Help
fi


##
## read command line
##
while [ $# -gt 0 ]
do
	case $1 in
		#-p project folder
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
			project=$1
			shift
		;;

		#-a all
		-a)
			project=
			shift
		;;

		#-s short
		-s)
			do_short=true
			shift
		;;

		#-h prints help and exists
		-h)		Help;exit 0;;

		*)	echo "$MOD_SCRIPT_NAME: undefined CLI option - $1"; exit 255;;
	esac
done


if [ -z $project ]; then
	for project in $PM_PROJECTS
	do
		echo ""
		echo "--------------------[ $project ]-------------------"
		echo ""
		if [ $do_short == true ]; then
			(cd $project; git status -b -s)
		else
			(cd $project; git status)
		fi
		echo ""
		echo "====================[ $project ]==================="
		echo ""
		echo ""
		echo ""
	done
else
	echo ""
	echo "--------------------[ $project ]-------------------"
	echo ""
	if [ $do_short == true ]; then
		(cd $project; git status -b -s)
	else
		(cd $project; git status)
	fi
	echo ""
	echo "====================[ $project ]==================="
	echo ""
fi


