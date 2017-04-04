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
## Task that merges a branch 'dev' back to master and takes care of most required edits.
## Call with project base directory (version taken from src/bundle/doc/CHANGELOG.asciidoc line 1)
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.4.0 build 170404 (04-Apr-17)


## script name for output
MOD_SCRIPT_NAME=`basename $0`


##
## Help screen and exit condition (i.e. too few arguments)
##
Help()
{
	echo ""
	echo "$MOD_SCRIPT_NAME - processes a project in dev branch up to create bundle"
	echo ""
	echo "       Usage:  $MOD_SCRIPT_NAME [-options]"
	echo ""
	echo "       Options"
	echo "         -h          - this help screen"
	echo "         -p FOLDER   - project to build as a folder relative from the current directory"
	echo "         -s          - show commands only, do not execute them"
	echo ""
	exit 255;
}
if [ $# -eq 0 ]; then
	Help
fi


# flag for showing commands only, default is false
show_only=false


##
## Function to show command or run it
##
RunCmd()
{
	if [ $show_only == true ]; then
		EchoCmd "CMD ==> $*"
	else
		$*
	fi
}

EchoCmd(){
	echo "CMD ==> $*"
}


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

		#-s show commands only
		-s)
			show_only=true
			shift
		;;

		#-h prints help and exists
		-h)		Help;exit 0;;

		*)	echo "$MOD_SCRIPT_NAME: undefined CLI option - $1"; exit 255;;
	esac
done


#check if we are on a dev branch and set master branch
_branch_dev=`(cd $project;git branch | grep \* | cut -d ' ' -f2)`
if [ "dev" != "$_branch_dev" ]; then
	if [ "dev-j7" != "$_branch_dev" ]; then
		echo ""
		echo "$project on branch $_branch_dev, need it to be on dev or dev-j7"
		exit 255
	fi
fi

_branch_master="master"
if [ "dev-j7" == "$_branch_dev" ]; then
	_branch_master="master-j7"
fi

if [ "`(cd $project;git branch --list $_branch_master)`" == "" ]; then
	echo ""
	echo "did not find expected master branch $_branch_master"
	exit 255
fi

if [ ! -f "$project/src/bundle/pm/project.properties" ]; then
	echo ""
	echo "no project.properties file found, need that to determine version"
	exit 255
fi

RunCmd vi $project/src/bundle/pm/project.properties
_version=`cat $project/src/bundle/pm/project.properties| grep "mvn.version=" | sed 's/.*=//' | tr [:cntrl:] '++' | sed 's/+//g'`


echo "processing"
echo " - project:       $project"
echo " - dev branch:    $_branch_dev"
echo " - master branch: $_branch_master"
echo " - version:       ($_version)"
echo ""
echo ""


_edit_files="$project/src/bundle/doc/CHANGELOG.adoc $project/src/bundle/doc/CHANGELOG.asciidoc $project/src/bundle/doc/README.asciidoc"
for file in $_edit_files
do
	if [ -f "$file" ]; then
		echo "- edit $file"
		RunCmd vi $file
	fi
done


## build README if script exists
if [ -f "$project/create-readme.sh" ]; then
	echo "- running create-readme.sh"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project;./create-readme.sh)"
	else
		(cd $project;./create-readme.sh)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem running 'create-readme.sh'"
			exit 255
		fi
	fi
fi


## generate sources if script exists
if [ -f "$project/mvn-generate-sources.sh" ]; then
	echo "- running mvn-generate-sources.sh"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project;./mvn-generate-sources.sh)"
	else
		(cd $project;./mvn-generate-sources.sh)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem running 'mvn-generate-sources.sh'"
			exit 255
		fi
	fi
fi


echo "- running 'mvn initialize' to generate new POM if needed"
RunCmd mvn initialize -q
if [ $show_only == false ]; then
	if [ $? -ne 0 ]; then
		echo ""
		echo "    -> problem running 'mvn initialize'"
		exit 255
	fi
fi


echo "- running 'mvn clean'"
if [ $show_only == true ]; then
	EchoCmd "(cd $project;mvn clean -q)"
else
	(cd $project;mvn clean -q)
	if [ $? -ne 0 ]; then
		echo ""
		echo "    -> problem running 'mvn clean'"
		exit 255
	fi
fi


echo "- running 'mvn package'"
if [ $show_only == true ]; then
	EchoCmd "(cd $project;mvn package -q)"
else
	(cd $project;mvn package -q)
	if [ $? -ne 0 ]; then
		echo ""
		echo "    -> problem running 'mvn package'"
		exit 255
	fi
fi


echo "- final add/commit/push on branch $_branch_dev"
if [ $show_only == true ]; then
	EchoCmd "(cd $project; git add .)"
	EchoCmd "(cd $project; git commit -m \"preparing to publish v${_version}\" .)"
	EchoCmd "(cd $project; git push origin $_branch_dev)"
else
	(cd $project; git add .)
	(cd $project; git commit -m "preparing to publish v${_version}" .)
	(cd $project; git push origin $_branch_dev)
fi


echo "- switching over to branch $_branch_master and merging with branch $_branch_dev"
if [ $show_only == true ]; then
	EchoCmd "(cd $project; git checkout $_branch_master)"
	EchoCmd "(cd $project; git commit -m \"preparing to publish v${_version}\" .)"
	EchoCmd "(cd $project; git push origin $_branch_master)"
	EchoCmd "(cd $project; git merge --no-ff -s recursive -X theirs $_branch_dev)"
	EchoCmd "(cd $project; git branch -d $_branch_dev)"
else
	(cd $project; git checkout $_branch_master)
	(cd $project; git commit -m "preparing to publish v${_version}" .)
	(cd $project; git push origin $_branch_master)
	(cd $project; git merge --no-ff -s recursive -X theirs $_branch_dev)
	(cd $project; git branch -d $_branch_dev)
fi

echo "- setting @version information in source files"
RunCmd ./bin/set-srcfile-versions.sh -p $project

echo "- running a full build"
RunCmd ./bin/build.sh -p $project -g install -b -s -j -t -c


if [ -d "$project/src/site" ]; then
	echo "- running 'mvn site'"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project;mvn site)"
	else
		(cd $project;mvn site)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem running 'mvn site'"
			exit 255
		fi
	fi
fi


echo "- commiting the source files"
if [ $show_only == true ]; then
	EchoCmd "(cd $project; git commit -m \"set file versions and passed tests for version v${_version}\" .)"
	EchoCmd "(cd $project; git push origin $_branch_master)"
else
	(cd $project; git commit -m "set file versions and passed tests for version v${_version}" .)
	(cd $project; git push origin $_branch_master)
fi


echo "- tagging new version"
if [ $show_only == true ]; then
	EchoCmd "(cd $project; git tag -a v${_version} -m \"new published version v${_version}\")"
	EchoCmd "(cd $project; git describe --tags)"
	EchoCmd "(cd $project; git push --tags)"
else
	(cd $project; git tag -a v${_version} -m "new published version v${_version}")
	(cd $project; git describe --tags)
	(cd $project; git push --tags)
fi


echo "- creating maven central bundle with signed artifacts"
RunCmd ./bin/create-bundle.sh $project


echo "==> finished"










#(cd $project; git checkout -b $_branch_dev $_branch_master)
#
#vi $project/src/bundle/pm/project.properties
#(cd $project; vi src/bundle/doc/CHANGELOG.asciidoc)
#
#(cd $project; git commit -m "started next version in change log" .)
#(cd $project; git push origin $_branch_dev)
