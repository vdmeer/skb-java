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
## My build script, loads a proper logback configuration and builds w/ or w/o tests
## Call -h for help
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.4.0 build 170404 (04-Apr-17)


## script name for output
MOD_SCRIPT_NAME=`basename $0`

## true for build with tests, false for w/o
do_tests=false

## true for running goal clean first, false for w/o
do_clean=false

## true for running goal site when finished standard goal, false for w/o
do_site=false

## true for running goal javadoc:javadoc first, when successful run standard goal, false for w/o
do_jd_jd=false

## true for generate bundle docs, false for w/o
do_bd=false

## true for generate a sources jar, false for w/o
do_src_jar=false

## true for generate a javadoc jar, false for w/o
do_jd_jar=false

## true for maven in quiet mode
mvn_quiet=false


## encoding for the Java compiler
file_encoding=UTF-8

## logback configuration file for the compiler
logback_configuration_file=../skb/base/src/main/resources/logback.xml


##
## check for Maven executable
##
type mvn >/dev/null 2>&1 || {
	echo >&2 "$MOD_SCRIPT_NAME: Maven (mvn) required but it's not installed.";

	## maven executable needs to be known
	if [ -z "$MAVEN" ] ; then
		echo "$MOD_SCRIPT_NAME: no maven executable set in environment either"
		echo " --> set \$MAVEN pointing your maven or install maven"
		echo ""
		exit 1
	fi
}

#now set maven executable
if [ -z "$MAVEN" ] ; then
	mvn=mvn
else
	mvn=${MAVEN}
fi



##
## Help screen and exit condition (i.e. too few arguments)
##
Help()
{
	echo ""
	echo "$MOD_SCRIPT_NAME - builds Maven projects"
	echo ""
	echo "       Usage:  $MOD_SCRIPT_NAME [-options]"
	echo ""
	echo "       Options"
	echo "         -a          - build everything, but not quiet, without tests, no site"
	echo "         -b          - generate bundle documentation (and copy to target)"
	echo "         -c          - run 'mvn clean' before the actual goal"
	echo "         -g GOAL     - Maven goal to build for"
	echo "         -h          - this help screen"
	echo "         -j          - generate javadoc jar"
	echo "         -jj         - run goal javadoc:javadoc (prints errors even when using asciidoctor"
	echo "         -p FOLDER   - project to build as a folder relative from the current directory"
	echo "         -q          - run maven in quiet mode"
	echo "         -r          - generate a sources jar"
	echo "         -s          - build a site after given goal"
	echo "         -t          - build with tests (if not present, build without tests)"
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

		#-g goal
		-g)
			shift
			if [ -z "$1" ]; then
				echo "$MOD_SCRIPT_NAME: no goal given"
				exit 255
			fi
			goal=$1
			shift
		;;

		#-a all build features
		-a)
			do_tests=false
			do_bd=true
			do_src_jar=true
			do_jd_jar=true
			do_clean=true
			do_jd_jd=true
			shift
		;;

		#-t with tests
		-t)
			do_tests=true
			shift
		;;

		#-b generate bundle documentation
		-b)
			do_bd=true
			shift
		;;

		#-r generate sources jar
		-r)
			do_src_jar=true
			shift
		;;

		#-j generate javadoc jar
		-j)
			do_jd_jar=true
			shift
		;;

		#-jj run javadoc:javadoc
		-jj)
			do_jd_jd=true
			shift
		;;

		#-q maven in quiet mode
		-q)
			mvn_quiet=true
			shift
		;;

		#-c run mvn clean
		-c)
			do_clean=true
			shift
		;;

		#-s run mvn site
		-s)
			do_site=true
			shift
		;;

		#-h prints help and exists
		-h)		Help;exit 0;;

		*)	echo "$MOD_SCRIPT_NAME: undefined CLI option - $1"; exit 255;;
	esac
done


if [ -z $project ]; then
	echo "$MOD_SCRIPT_NAME: building for ALL projects"
else
	echo "$MOD_SCRIPT_NAME: building for project $project"
fi

if [ -z $goal ]; then
	echo "$MOD_SCRIPT_NAME: no goal given"
	exit 255
else
	echo "$MOD_SCRIPT_NAME: building for goal $goal"
fi
if [ $do_clean == true ]; then
	echo "$MOD_SCRIPT_NAME: running 'clean' before '$goal'"
	goal="clean $goal"
fi
if [ $do_site == true ]; then
	echo "$MOD_SCRIPT_NAME: running 'site' after '$goal'"
	goal="$goal site"
fi

if [ $do_tests == true ]; then
	echo "$MOD_SCRIPT_NAME: building with tests"
	test_arg=
else
	echo "$MOD_SCRIPT_NAME: building without tests"
	test_arg="-DskipTests"
fi

if [ $do_jd_jd == true ]; then
	echo "$MOD_SCRIPT_NAME: running 'javadoc:javadoc' before '$goal'"
	goal="javadoc:javadoc $goal"
fi



profiles_arg=""
if [ $do_bd == true ]; then
	echo "$MOD_SCRIPT_NAME: generating bundle docs"
	if [ "$profiles_arg" != "" ]; then
		profiles_arg="${profiles_arg},"
	fi
	profiles_arg="${profiles_arg}env-bdoc"
else
	echo "$MOD_SCRIPT_NAME: no bundle docs"
fi

if [ $do_src_jar == true ]; then
	echo "$MOD_SCRIPT_NAME: generating sources jar"
	if [ "$profiles_arg" != "" ]; then
		profiles_arg="${profiles_arg},"
	fi
	profiles_arg="${profiles_arg}env-srcjar"
else
	echo "$MOD_SCRIPT_NAME: no sources jar"
fi

if [ $do_jd_jar == true ]; then
	echo "$MOD_SCRIPT_NAME: generating javadoc jar"
	if [ "$profiles_arg" != "" ]; then
		profiles_arg="${profiles_arg},"
	fi
	profiles_arg="${profiles_arg}env-jdjar"
else
	echo "$MOD_SCRIPT_NAME: no javadoc jar"
fi


maven_arg="$goal -DargLine=\"-Dfile.encoding=${file_encoding} -Dlogback.configurationFile=${logback_configuration_file}\" $test_arg"
if [ "$profiles_arg" != "" ]; then
	maven_arg="$maven_arg -P $profiles_arg"
fi

if [ $mvn_quiet == true ]; then
	echo "$MOD_SCRIPT_NAME: running maven in quiet mode"
	maven_arg="$maven_arg -q"
fi


if [ -z $project ]; then
	$mvn $maven_arg
	if [ $? -ne 0 ]; then
		echo ""
		echo "    -> problem running '$mvn $maven_arg'"
		exit 255
	fi
else
	$mvn -pl $project $maven_arg
	if [ $? -ne 0 ]; then
		echo ""
		echo "    -> problem running '$mvn -pl $project $maven_arg'"
		exit 255
	fi
fi

exit 0
