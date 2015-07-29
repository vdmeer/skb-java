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
## Task that tests infrastructure for Module.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v1.0.0 build 150729 (29-Jul-15)

##
## call with sourced settings file
##

if [ ! -d $MOD_TARGET_MODULES_DIR ]; then
	echo "no target directory found, cannot proceed, try option -i"
	exit 255
fi
if [ ! -f $MOD_FILE_VERSION_BASH ]; then
	echo "no version file for BASH found, cannot proceed, try option -i"
	exit 255
fi
if [ ! -f $MOD_TARGET_MODULES_DIR/$skb_module_artifact.bash ]; then
	echo "no BASH settings file for module <$skb_module_artifact> found, cannot proceed, try option -i for module <$skb_module_artifact>"
	exit 255
fi

echo "------> all files ok for module <$skb_module_artifact>"
