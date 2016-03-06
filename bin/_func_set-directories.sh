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
## Sets directories: absolute (OS specific) and sh (non OS specific absolute).
## Source file, call function, will set variables "_home_abs" and "_home_sh"
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.3.0 build 160306 (06-Mar-16)


##
## Sets directories for specific systems (call GetSystem first)
##
SetDirectories()
{
	_home_abs=`pwd`

	CP=${LIB_HOME}/*
	SCRIPT_NAME=`basename $0`

	echo "set directories: $_system"
	if [ "$_system" == "CYGWIN" ] ; then
		if [[ $_home_abs == *"/cygdrive"* ]]; then
			_home_sh="/"`echo $_home_abs | cut -d/ -f4-`
		else
			_home_sh=${_home_abs}
		fi
	else
		_home_sh=${_home_abs}
	fi
}
