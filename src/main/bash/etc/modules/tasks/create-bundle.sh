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
## Task that creates a bundle Module.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)

##
## call with sourced settings file
##

if [ -d "$skb_module_directory/target" ] ; then
	if [ ! -d $MOD_TARGET_DIR ]; then
		mkdir $MOD_TARGET_DIR
	fi
	if [ ! -d $MOD_TARGET_DIR/bundles ]; then
		mkdir $MOD_TARGET_DIR/bundles
	fi
	if [ ! -d $MOD_TARGET_DIR/bundles/$skb_module_artifact ]; then
		mkdir $MOD_TARGET_DIR/bundles/$skb_module_artifact
	fi
	cp $skb_module_directory/target/*.jar $MOD_TARGET_DIR/bundles/$skb_module_artifact
	cp $skb_module_directory/pom.xml $MOD_TARGET_DIR/bundles/$skb_module_artifact

	for i in ` find $MOD_TARGET_DIR/bundles/$skb_module_artifact -type f`
	do
		chmod 640 $i
		gpg -ab $i
	done

	(cd $MOD_TARGET_DIR/bundles/$skb_module_artifact; tar cvfz ../$skb_module_artifact.tar.gz *)
else
	echo "------> no target directory, try 'mvn package' first"
fi
