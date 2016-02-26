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
## Task that merges a branch 'dev' back to master and prepares for creating a bundle.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.1.0 build 160226 (26-Feb-16)

##
## call with sourced settings file
##

(cd $skb_module_directory; vi src/bundle/doc/CHANGELOG.asciidoc)
(cd $skb_module_directory; vi src/bundle/doc/README.asciidoc)


(cd $skb_module_directory; git add .)
(cd $skb_module_directory; git commit -m "final edits for v${skb_module_version}" .)
(cd $skb_module_directory; git push origin dev)

(cd $skb_module_directory; git checkout master)
(cd $skb_module_directory; git commit -m "final edits for v${skb_module_version}" .)
(cd $skb_module_directory; git push origin master)
(cd $skb_module_directory; git merge --no-ff -s recursive -X theirs dev)
(cd $skb_module_directory; git branch -d dev)

if [ -z "$skb_module_alias" ]; then
	$MOD_SCRIPT_DIR/$MOD_SCRIPT_NAME -m $skb_module_artifact -t set-versions
else
	$MOD_SCRIPT_DIR/$MOD_SCRIPT_NAME -m $skb_module_alias -t set-versions
fi

(cd $skb_module_directory; mvn clean)
(cd $skb_module_directory; mvn package)

(cd $skb_module_directory; git commit -m "final edits for v${skb_module_version}" .)
(cd $skb_module_directory; git push origin master)

(cd $skb_module_directory; git tag -a v${skb_module_version} -m "version v${skb_module_version}")
(cd $skb_module_directory; git describe --tags)
(cd $skb_module_directory; git push --tags)

(cd $skb_module_directory; git checkout -b dev master)
