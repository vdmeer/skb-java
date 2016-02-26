#!/bin/bash

## Copyright 2014-2015 Sven van der Meer <vdmeer.sven@mykolab.com>
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
## Task that deploys an application Module.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)

##
## call with sourced settings file
## requires PROJECT_APPS_DIR set to a an existing folder for deployment
##

if [ -z "$PROJECT_APPS_DIR" ]; then
	echo "------> no application deployment directory set"
	exit 255
fi

if [ -d "$skb_module_directory/target/application" ] ; then
	if [ -d "$PROJECT_APPS_DIR" ]; then
		for tarfile in `ls $skb_module_directory/target/application|grep tar`
		do
			(cd $PROJECT_APPS_DIR; rm -fr $skb_module_appdir_name)
			(cd $PROJECT_APPS_DIR; mkdir $skb_module_appdir_name)
			cp $skb_module_directory/target/application/$tarfile $PROJECT_APPS_DIR/$skb_module_appdir_name
			(cd $PROJECT_APPS_DIR/$skb_module_appdir_name; tar xvfz $tarfile)
			(cd $PROJECT_APPS_DIR/$skb_module_appdir_name; rm $tarfile)
			(cd $PROJECT_APPS_DIR/$skb_module_appdir_name/bin; ./init.sh)
		done
	else
		echo "------> deployment directory does not exist: ${PROJECT_APPS_DIR}"
	fi
else
	echo "------> no folder for application found"
fi
