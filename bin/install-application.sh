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
## Task that installs an ExecS application into a given or standard folder and runs the init scripts.
## Call with project base directory and installation directory (if empty: ./target/application
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)

inst_dir=
if [ -z "$2" ]; then
	mkdir -p target/application
	inst_dir=target/application/
else
	if [ ! -d "$2" ]; then
		mkdir -p $2
	fi
	inst_dir=$2
fi
echo "installing into directory <$inst_dir>"

if [ ! -f "$1/pom.xml" ]; then
	echo "no project found in <$1>"
	exit 255
fi
base_dir=$1
echo -n "processing -> $base_dir"

if [ ! -d "$base_dir/target/application" ]; then
	echo
	echo "no folder <$base_dir/target/application> found"
	exit 255
fi
app_dir=$base_dir/target/application
echo -n "/target/application"

tar_file=`(cd $app_dir; ls|grep tar)`
if [ -z "$tar_file" ]; then
	echo
	echo "no tar file found in  <$app_dir>"
	exit 255
fi
echo "/$tar_file"

echo ""
ls $inst_dir
rm -rI $inst_dir/*
cp $base_dir/target/application/$tar_file $inst_dir
(cd $inst_dir; tar xvfz $tar_file; rm $tar_file; cd bin; ./init.sh)
