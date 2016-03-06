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
## Sets file versions for a particular project using given version properties.
## Call
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.3.0 build 160306 (06-Mar-16)


## script directory, from https://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
export MOD_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
## script name for error/info messages
export MOD_SCRIPT_NAME=`basename $0`


source $MOD_SCRIPT_DIR/_func_get-system.sh
GetSystem


source $MOD_SCRIPT_DIR/_func_set-directories.sh
SetDirectories


ant="ant -f src/bundle/pm/set-versions/build.xml -DversionFile=$_home_sh/src/bundle/pm/set-versions/versions.properties"

projects=`cat src/bundle/pm/projects.pm`
for dir in $projects
do
	prj_dir=`echo $dir | sed -e 's/^.*=//'`
	$ant -DmoduleDir=$_home_sh/$prj_dir -DmoduleFile=$_home_sh/$prj_dir/src/bundle/pm/project.properties
done
