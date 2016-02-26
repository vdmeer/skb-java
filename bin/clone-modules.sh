#!/bin/bash

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
## Script to clone all SKB projects from GitHub.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2016 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)
##

moddir=../../

if [ ! -d $moddir ]; then
	mkdir $moddir
fi

if [ ! -d $moddir/execs ]; then
	(cd $moddir; git clone https://github.com/vdmeer/execs.git)
fi

if [ ! -d $moddir/asciitable ]; then
	(cd $moddir; git clone https://github.com/vdmeer/asciitable.git)
fi

if [ ! -d $moddir/svg2vector ]; then
	(cd $moddir; git clone https://github.com/vdmeer/svg2vector.git)
fi

if [ ! -d $moddir/base ]; then
	(cd $moddir; git clone https://github.com/vdmeer/skb-java-base.git base)
fi

if [ ! -d $moddir/categories ]; then
	(cd $moddir; git clone https://github.com/vdmeer/skb-java-categories.git categories)
fi

if [ ! -d $moddir/commons ]; then
	(cd $moddir; git clone https://github.com/vdmeer/skb-java-commons.git commons)
fi

if [ ! -d $moddir/configuration ]; then
	(cd $moddir; git clone https://github.com/vdmeer/skb-java-configuration.git configuration)
fi

if [ ! -d $moddir/examples ]; then
	(cd $moddir; git clone https://github.com/vdmeer/skb-java-examples.git examples)
fi
