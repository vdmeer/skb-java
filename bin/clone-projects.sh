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
## Simply call, all clones will be done in the project directory
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2016 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.4.0 build 170404 (04-Apr-17)
##

prjdir=projects/


if [ ! -d "$prjdir/app" ]; then
	mkdir $prjdir/app
fi
(cd $prjdir/app;git clone git@github.com:vdmeer/skb-java-datatool.git;mv skb-java-datatool datatool)
(cd $prjdir/app;git clone git@github.com:vdmeer/skb-java-examples.git;mv skb-java-examples examples)
(cd $prjdir/app;git clone git@github.com:vdmeer/svg2vector.git)


if [ ! -d "$prjdir/ascii" ]; then
	mkdir $prjdir/ascii
fi
(cd $prjdir/ascii;git clone git@github.com:vdmeer/ascii-utf-themes.git;mv ascii-utf-themes art)
(cd $prjdir/ascii;git clone git@github.com:vdmeer/char-translation.git)
#(cd $prjdir/ascii;git clone 
(cd $prjdir/ascii;git clone git@github.com:vdmeer/asciilist.git;mv asciilist list)
(cd $prjdir/ascii;git clone git@github.com:vdmeer/asciiparagraph.git;mv asciiparagraph paragraph)
(cd $prjdir/ascii;git clone git@github.com:vdmeer/asciitable.git;mv asciitable table)


if [ ! -d "$prjdir/core" ]; then
	mkdir $prjdir/core
fi
(cd $prjdir/core;git clone git@github.com:vdmeer/skb-java-interfaces.git;mv skb-java-interfaces interfaces)
(cd $prjdir/core;git clone git@github.com:vdmeer/skb-java-base.git;mv skb-java-base base)


if [ ! -d "$prjdir/j7" ]; then
	mkdir $prjdir/j7
fi
(cd $prjdir/j7;git clone git@github.com:vdmeer/asciilist.git;mv asciilist list)
(cd $prjdir/j7/list/;git checkout master-j7)
(cd $prjdir/j7;git clone git@github.com:vdmeer/asciiparagraph.git;mv asciiparagraph paragraph)
(cd $prjdir/j7/paragraph/;git checkout master-j7)
(cd $prjdir/j7;git clone git@github.com:vdmeer/asciitable.git;mv asciitable table)
(cd $prjdir/j7/table/;git checkout master-j7)


if [ ! -d "$prjdir/svc" ]; then
	mkdir $prjdir/svc
fi
(cd $prjdir/svc;git clone git@github.com:vdmeer/execs.git)
(cd $prjdir/svc;git clone git@github.com:vdmeer/project-manager-maven-plugin.git;mv project-manager-maven-plugin project-manager)
