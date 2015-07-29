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
## Task that sets version information of source files for Module.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v1.0.0 build 150729 (29-Jul-15)

##
## call with sourced settings file
## requires ANT
##

path=$MOD_ETC_DIR/ant-macros/set-versions.build.xml

module_file=$skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact.settings
module_dir=$skb_module_directory
system=`uname -o`

if [ "$system" == "Cygwin" ] ; then
	path=`cygpath -m ${path}`
	module_file=`cygpath -m ${module_file}`
	module_dir=`cygpath -m ${module_dir}`
fi

ant -S -f $path -DmoduleFile=$module_file -DmoduleDir=$module_dir
