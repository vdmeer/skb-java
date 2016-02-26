#!/bin/bash

## Copyright 2014-2016 Sven van der Meer <vdmeer.sven@mykolab.com>
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
## Script to create environment settings required by the modules script.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2016 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)
##

pwd=`pwd`
file=bin/env.settings

echo "creating environment settings"

echo "" > ${file}

echo "# File containing environment settings or modules" >> ${file}
echo "#" >> ${file}
echo "# - blank lines are ignored" >> ${file}
echo "# - lines starting with '#' are ignored (i.e. are comments)" >> ${file}
echo "# - other lines are read as \"NAME VALUE\"" >> ${file}
echo "#   -> reference to other variables using \${NAME}" >> ${file}
echo "#" >> ${file}
echo "# -> use source-bash or source-tcsh to set in shell" >> ${file}
echo "#" >> ${file}
echo "#" >> ${file}
echo "" >> ${file}
echo "PROJECT_HOME ${pwd}" >> ${file}
echo "PROJECT_APPS_DIR ${pwd}/../applications" >> ${file}
if [ -f src/module/build-versions.skb ];then
	echo "PROJECT_BUILD_VERSION_FILE $PROJECT_HOME/src/module/build-versions.skb" >> ${file}
else
	echo "no build-versions.skb file found, automatic external dependency generation will not work"
fi
echo "MVN_GROUP_ID de.vandermeer" >> ${file}
echo "" >> ${file}

mkdir ../applications >& /dev/null
mkdir /tmp/logs >& /dev/null
mkdir /tmp/logs/skb >& /dev/null

exit 0
