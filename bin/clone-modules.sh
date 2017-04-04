#!/usr/bin/env bash

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
## Script to clone all active SKB projects from GitHub.
## Simply call, all clones will be done in the parent directory
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2016 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.3.0 build 170404 (04-Apr-17)
##

moddir=../

active_projects="asciilist asciiparagraph asciitable execs svg2vector"
active_projects_skb_java="base datatool examples"
active_projects_plugins="project-manager"

for prj in $active_projects
do
	(cd $moddir; git clone https://github.com/vdmeer/$prj.git $prj)
done

for prj in $active_projects_skb_java
do
	(cd $moddir; git clone https://github.com/vdmeer/skb-java-$prj.git $prj)
done

mkdir $moddir/mvn
for prj in $active_projects_plugins
do
	(cd $moddir; git clone https://github.com/vdmeer/$prj-maven-plugin.git mvn/$prj)
done
