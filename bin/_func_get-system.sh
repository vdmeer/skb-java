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
## Function to determine the UNIX system a script is executed on.
## Source file, call function, will set variable "_system"
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.3.0 build 170404 (04-Apr-17)


## Get system, need this information for creating build scripts
## taken from: https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux#3466183 - see there for details
_system=
GetSystem()
{
	case "$(uname -s)" in
		Darwin)
			echo 'found Mac OS X'
			_system=MAC
			;;
		Linux)
			echo 'Linux'
			_system=LINUX
			;;
		CYGWIN*)
			echo 'found Cygwin'
			_system=CYGWIN
			;;
		MINGW32*|MSYS*)
			echo 'found MS Windows'
			_system=WINDOWS
			;;
		*)
			echo 'found other OS'
			_system="???" 
			;;
	esac
}
