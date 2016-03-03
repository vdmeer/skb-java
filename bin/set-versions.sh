#!/bin/bash

system=`uname -o`
home_abs=`pwd`

if [ "$system" == "Cygwin" ] ; then
	if [[ $home_abs == *"/cygdrive"* ]]; then
		home_sh="/"`echo $home_abs | cut -d/ -f4-`
	else
		home_sh=${home_abs}
	fi
else
	home_sh=${home_abs}
fi

ant="ant -f src/bundle/pm/set-versions/build.xml -DversionFile=$home_sh/src/bundle/pm/set-versions/versions.properties"

projects=`cat src/bundle/pm/projects.pm`
for dir in $projects
do
	prj_dir=`echo $dir | sed -e 's/^.*=//'`
	$ant -DmoduleDir=$home_sh/$prj_dir -DmoduleFile=$home_sh/$prj_dir/src/bundle/pm/project.properties
done

#ant -f src/bundle/pm/set-versions/build.xml -DmoduleFile=$home_sh/../mvn/project-manager/src/bundle/pm/project.properties -DmoduleDir=$home_sh/../mvn/project-manager
#
#-DmoduleFile=$home_sh/../asciiparagraph/src/bundle/pm/project.properties
#-DmoduleDir=$home_sh/../asciiparagraph
#
#-DmoduleFile=$home_sh/../asciitable/src/bundle/pm/project.properties
#-DmoduleDir=$home_sh/../asciitable
#
#-DmoduleFile=$home_sh/../asciilist/src/bundle/pm/project.properties
#-DmoduleDir=$home_sh/../asciilist
#
#-DmoduleFile=$home_sh/../execs/src/bundle/pm/project.properties
#-DmoduleDir=$home_sh/../execs
#
#-DmoduleFile=$home_sh/../base/src/bundle/pm/project.properties
#-DmoduleDir=$home_sh/../base
#
#-DmoduleFile=$home_sh/../datatool/src/bundle/pm/project.properties
#-DmoduleDir=$home_sh/../datatool
#
#-DmoduleFile=$home_sh/../examples/src/bundle/pm/project.properties
#-DmoduleDir=$home_sh/../examples
