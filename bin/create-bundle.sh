#!/bin/bash

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
## Task that creates a bundle with signed artifacts for a project.
## Call with project base directory
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)

##
## call with sourced settings file
##

if [ ! -d target ]; then
	mkdir target
fi
if [ ! -d target/bundles ]; then
	mkdir target/bundles
fi

if [ -d "$1/target" ]; then
	source=$1
	echo "processing <$source>"
	_p=(`echo $source | sed -e 's/\// /g'`)
	target=target/bundles/${_p[-1]}
	bundle_name=${_p[-1]}
	rm -fr $target >& /dev/null
	mkdir $target >&/dev/null
	cp $source/target/*.jar $target
	rm $target/*with-dependencies.jar
	cp $source/pom.xml $target
	chmod 644 $target/*
	for i in `find $target -type f`
	do
		gpg -ab $i
	done
	chmod 644 $target/*
	rm target/bundles/$bundle_name.zip >& /dev/null
	(cd $target; zip $bundle_name *;mv $bundle_name.zip ..)
else
	echo "no target folder found in <$1>"
fi

echo "finished"
