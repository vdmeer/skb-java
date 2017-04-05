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
		EchoCmd "$*"
	else
		$*
	fi
}

##
## Function to simply show a command with a prefix
##
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
			project=$1
			if [ ! -d "$1" ]; then
				echo "$MOD_SCRIPT_NAME: given project folder <$project> does not exist?"
				exit 255
			fi
			if [ ! -f "$1/pom.xml" ]; then
				echo "$MOD_SCRIPT_NAME: no POM file found in project folder <$project>"
				exit 255
			fi
			if [ ! -f "$project/src/bundle/pm/project.properties" ]; then
				echo "$MOD_SCRIPT_NAME: no project.properties file found in project $project"
				exit 255
			fi
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



# name of a file with an entry point (for picking up where last things went wrong)
entry_point_fn=_entry-point

# an entry point to jump to
entry_point=0

if [ -f "$project/$entry_point_fn" ]; then
	typeset -i entry_point=$(cat $project/$entry_point_fn)
else
	echo $entry_point > $project/$entry_point_fn
fi

echo "$MOD_SCRIPT_NAME: using entry point $entry_point"


## detect current branch
_branch_current=`(cd $project;git branch | grep \* | cut -d ' ' -f2)`
case "$_branch_current" in
	dev*)
		if [ $entry_point -ge 99 ]; then
			echo "$MOD_SCRIPT_NAME: entry point > 99, should be on 'master' branch"
			exit -255
		fi
		;;
	master*)
		if [ $entry_point -lt 99 ]; then
			echo "$MOD_SCRIPT_NAME: entry point < 99, should be on 'dev' branch"
			exit -255
		fi
		;;
esac


## set dev and master branches
case "$_branch_current" in
	*-j7)
		_branch_dev=`(cd $project;git for-each-ref --format='%(refname:short)' refs/heads/ | grep dev-j7)`
		if [ "$_branch_dev" != "dev-j7" ]; then
			echo "$MOD_SCRIPT_NAME: did not find a 'dev' branch, tried 'dev-j7'"
			exit 200
		fi
		_branch_master=`(cd $project;git for-each-ref --format='%(refname:short)' refs/heads/ | grep master-j7)`
		if [ "$_branch_master" != "master-j7" ]; then
			echo "$MOD_SCRIPT_NAME: did not find a 'master' branch, tried 'master-j7'"
			exit 210
		fi
		;;
	dev)
		echo "dev"
		_branch_dev=`(cd $project;git for-each-ref --format='%(refname:short)' refs/heads/ | grep dev)`
		if [ "$_branch_dev" != "dev" ]; then
			echo "$MOD_SCRIPT_NAME: did not find a 'dev' branch, tried 'dev'"
			exit 220
		fi
		_branch_master=`(cd $project;git for-each-ref --format='%(refname:short)' refs/heads/ | grep master)`
		if [ "$_branch_master" != "master" ]; then
			echo "$MOD_SCRIPT_NAME: did not find a 'master' branch, tried 'master'"
			exit 230
		fi
		;;
	master)
		echo "master"
		_branch_dev=`(cd $project;git for-each-ref --format='%(refname:short)' refs/heads/ | grep dev)`
		if [ $entry_point -lt 101 ]; then
			if [ "$_branch_dev" != "dev" ]; then
				echo "$MOD_SCRIPT_NAME: did not find a 'dev' branch, tried 'dev'"
				echo $_branch_dev
				exit 240
			fi
		else
			_branch_dev="<deleted in 101>"
		fi
		_branch_master=`(cd $project;git for-each-ref --format='%(refname:short)' refs/heads/ | grep master)`
		if [ "$_branch_master" != "master" ]; then
			echo "$MOD_SCRIPT_NAME: did not find a 'master' branch, tried 'master'"
			exit 250
		fi
		;;

esac


## ep=1
if [ $entry_point -lt 1 ]; then
	RunCmd vi $project/src/bundle/pm/project.properties
	echo 1 > $project/$entry_point_fn
fi
_version=`cat $project/src/bundle/pm/project.properties| grep "mvn.version=" | sed 's/.*=//' | tr [:cntrl:] '++' | sed 's/+//g'`


echo "processing"
echo " - project:        $project"
echo " - current branch: $_branch_current"
echo " - dev branch:     $_branch_dev"
echo " - master branch:  $_branch_master"
echo " - version:        $_version"
echo ""
echo ""


## ep=2
if [ $entry_point -lt 2 ]; then
	_edit_files="$project/src/bundle/doc/CHANGELOG.adoc $project/src/bundle/doc/CHANGELOG.asciidoc $project/src/bundle/doc/README.asciidoc"
	for file in $_edit_files
	do
		if [ -f "$file" ]; then
			echo "- edit $file"
			RunCmd vi $file
		fi
	done
	echo 2 > $project/$entry_point_fn
fi


## ep=3
if [ $entry_point -lt 3 ]; then
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
	echo 3 > $project/$entry_point_fn
fi


## ep=4
if [ $entry_point -lt 4 ]; then
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
	echo 4 > $project/$entry_point_fn
fi


## ep=5
if [ $entry_point -lt 5 ]; then
	echo "- running 'mvn initialize' to generate new POM if needed"
	RunCmd mvn initialize -q
	if [ $show_only == false ]; then
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem running 'mvn initialize'"
			exit 255
		fi
	fi
	echo 5 > $project/$entry_point_fn
fi


## ep=6
if [ $entry_point -lt 6 ]; then
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
	echo 6 > $project/$entry_point_fn
fi


## ep=7
if [ $entry_point -lt 7 ]; then
	echo "- running a full build"
	RunCmd ./bin/build.sh -p $project -g install -b -s -j -t -c -q
	_ex=$?
	if [ $show_only != true ]; then
		if [ $_ex -ne 0 ]; then
			echo ""
			echo "    -> problem running a full build"
			exit 255
		fi
	fi
	echo 7 > $project/$entry_point_fn
fi


## ep=8
if [ $entry_point -lt 8 ]; then
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
	echo 8 > $project/$entry_point_fn
fi


## ep=99
if [ $entry_point -lt 99 ]; then
	echo "- switching over to branch '$_branch_master'"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git checkout $_branch_master)"
	else
		(cd $project; git checkout $_branch_master)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem switching over to branch '$_branch_master'"
			exit 255
		fi
	fi
	echo 99 > $project/$entry_point_fn
fi


## ep=100
if [ $entry_point -lt 100 ]; then
	echo "- merging '$_branch_master' with '$_branch_dev'"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git merge --no-ff -s recursive -X theirs $_branch_dev)"
	else
		(cd $project; git merge --no-ff -s recursive -X theirs $_branch_dev)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem merging '$_branch_master' with '$_branch_dev'"
			exit 255
		fi
	fi
	echo 100 > $project/$entry_point_fn
fi


## ep=101
if [ $entry_point -lt 101 ]; then
	echo "- removing '$_branch_dev'"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git branch -d $_branch_dev)"
	else
		(cd $project; git branch -d $_branch_dev)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem removing '$_branch_dev'"
			exit 255
		fi
	fi
	echo 101 > $project/$entry_point_fn
fi



## ep=102
if [ $entry_point -lt 102 ]; then
	echo "- setting @version information in source files"
	RunCmd ./bin/set-srcfile-versions.sh -p $project
	_ex=$?
	if [ $show_only != true ]; then
		if [ $_ex -ne 0 ]; then
			echo ""
			echo "    -> problem setting @version information in source files"
			exit 255
		fi
	fi
	echo 102 > $project/$entry_point_fn
fi


## ep=103
if [ $entry_point -lt 103 ]; then
	echo "- running a full build"
	RunCmd ./bin/build.sh -p $project -g install -b -s -j -t -c -q
	_ex=$?
	if [ $show_only != true ]; then
		if [ $_ex -ne 0 ]; then
			echo ""
			echo "    -> problem running a full build"
			exit 255
		fi
	fi
	echo 103 > $project/$entry_point_fn
fi


## ep=104
if [ $entry_point -lt 104 ]; then
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
	echo 104 > $project/$entry_point_fn
fi


## ep=105
if [ $entry_point -lt 105 ]; then
	echo "- commiting the source files"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git commit -m \"set file versions and passed tests for version v${_version}\" .)"
	else
		(cd $project; git commit -m "set file versions and passed tests for version v${_version}" .)
	fi
	echo 105 > $project/$entry_point_fn
fi


## ep=106
if [ $entry_point -lt 106 ]; then
	echo "- pushing origin to '$_branch_master'"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git push origin $_branch_master)"
	else
		(cd $project; git push origin $_branch_master)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem pushing origin to '$_branch_master'"
			exit 255
		fi
	fi
	echo 106 > $project/$entry_point_fn
fi


## ep=107
if [ $entry_point -lt 107 ]; then
	echo "- tagging new version"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git tag -a v${_version} -m \"new published version v${_version}\")"
	else
		(cd $project; git tag -a v${_version} -m "new published version v${_version}")
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem tagging new version"
			exit 255
		fi
	fi
	echo 107 > $project/$entry_point_fn
fi


## ep=108
if [ $entry_point -lt 108 ]; then
	echo "- describe tag"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git describe --tags)"
	else
		_tag=`(cd $project; git describe --tags)`
#		if [ "$tag" != "v${_version}" ]; then
#			echo ""
#			echo "    -> problem describe tag"
#			exit 255
#		fi
	fi
	echo 108 > $project/$entry_point_fn
fi


## ep=109
if [ $entry_point -lt 109 ]; then
	echo "- pushgin new tag"
	if [ $show_only == true ]; then
		EchoCmd "(cd $project; git push --tags)"
	else
		(cd $project; git push --tags)
		if [ $? -ne 0 ]; then
			echo ""
			echo "    -> problem pushgin new tag"
			exit 255
		fi
	fi
	echo 109 > $project/$entry_point_fn
fi


## ep=110
if [ $entry_point -lt 110 ]; then
	echo "- creating maven central bundle with signed artifacts"
	RunCmd ./bin/create-bundle.sh $project
	if [ $? -ne 0 ]; then
		echo ""
		echo "    -> problem creating maven central bundle with signed artifacts"
		exit 255
	fi
	echo 110 > $project/$entry_point_fn
fi


echo "==> finished"
rm $project/$entry_point_fn



#(cd $project; git checkout -b $_branch_dev $_branch_master)
#
#vi $project/src/bundle/pm/project.properties
#(cd $project; vi src/bundle/doc/CHANGELOG.asciidoc)
#
#(cd $project; git commit -m "started next version in change log" .)
#(cd $project; git push origin $_branch_dev)
