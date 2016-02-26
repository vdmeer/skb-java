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
## @version    v2.1.0 build 160226 (26-Feb-16)

##
## call with sourced settings file
##

echo -n "."
fn_settings=$skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact.settings

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.description`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.description"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.internalDependencies`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.internalDependencies"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.version`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.version"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.alias`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.alias"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.name`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.name"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.url`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.url"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.inceptionYear`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.inceptionYear"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.packaging`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.packaging"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.properties.compiler.source`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.properties.compiler.source"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.properties.compiler.target`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.properties.compiler.target"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.properties.encoding`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.properties.encoding"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.scm.developerConnection`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.scm.developerConnection"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.scm.connection`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.scm.connection"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.scm.url`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.scm.url"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.issueManagement.url`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.issueManagement.url"
fi

echo -n "."
if [ -z "`cat $fn_settings | grep skb.module.issueManagement.system`" ]; then
	echo ""
	echo "---> settings missing argument ==> skb.module.issueManagement.system"
fi

echo -n "-> settings ok "
