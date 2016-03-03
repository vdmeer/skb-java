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
## Task that merges a branch 'dev' back to master and takes care of most required edits.
## Call with project base directory (version taken from src/bundle/doc/CHANGELOG.asciidoc line 1)
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.3.0 build 160303 (03-Mar-16)


if [ ! -f "$1/pom.xml" ]; then
	echo "no project found in <$1>"
	exit 255
fi
base_dir=$1
echo -n "processing <$base_dir>"

if [ ! -f "$base_dir/src/bundle/doc/CHANGELOG.asciidoc" ]; then
	echo ""
	echo "no CHANGELOG file found, need that to determine version"
	exit 255
fi
_v=(`head $base_dir/src/bundle/doc/CHANGELOG.asciidoc -n 1`)
version=`echo ${_v[0]} | sed -e 's/v//'`
echo -n " for version <$version>"

branch=`(cd $1; git rev-parse --abbrev-ref HEAD)`
if [ "dev" != "$branch" ]; then
	echo ""
	echo "<$1> not on branch <$branch>, need it to be on <dev>"
	exit 255
fi
echo " on branch $branch"

(cd $base_dir; vi src/bundle/pm/project.properties)
(cd $base_dir; vi src/bundle/doc/CHANGELOG.asciidoc)
(cd $base_dir; vi src/bundle/doc/README.asciidoc)
(cd $base_dir; vi pom.xml)

(cd $base_dir; git add .)
(cd $base_dir; git commit -m "preparing to publish v${version}" .)
(cd $base_dir; git push origin dev)

(cd $base_dir; git checkout master)
(cd $base_dir; git commit -m "preparing to publish v${version}" .)
(cd $base_dir; git push origin master)
(cd $base_dir; git merge --no-ff -s recursive -X theirs dev)
(cd $base_dir; git branch -d dev)

./bin/set-versions.sh
mvn initialize

(cd $base_dir; mvn clean install)

(cd $base_dir; git commit -m "set file versions and passed tests for version v${version}" .)
(cd $base_dir; git push origin master)

(cd $base_dir; git tag -a v${version} -m "new published version v${version}")
(cd $base_dir; git describe --tags)
(cd $base_dir; git push --tags)

./bin/create-bundle.sh $base_dir

(cd $base_dir; git checkout -b dev master)

(cd $base_dir; vi src/bundle/doc/CHANGELOG.asciidoc)

(cd $base_dir; git commit -m "started next version in change log" .)
(cd $base_dir; git push origin dev)

