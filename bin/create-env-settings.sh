#!/bin/bash

pwd=`pwd`
file=bin/env.settings

echo "creating environment settings"

echo "" > ${file}

echo "# File containing environment settings or modules" >> ${file}
echo "#" >> ${file}
echo "# - blank lines are ignored" >> ${file}
echo "# - lines starting with '#' are ignored (i.e. are comments)" >> ${file}
echo "# - other lines are read as \"NAME VALUE\"" >> ${file}
echo "#   -> reference to other variables using \${NAME}" >> ${file}
echo "#" >> ${file}
echo "# -> use source-bash or source-tcsh to set in shell" >> ${file}
echo "#" >> ${file}
echo "#" >> ${file}
echo "" >> ${file}
echo "PROJECT_HOME ${pwd}" >> ${file}
echo "PROJECT_APPS_DIR ${pwd}/../applications" >> ${file}
if [ -f src/module/build-versions.skb ];then
	echo "PROJECT_BUILD_VERSION_FILE $PROJECT_HOME/src/module/build-versions.skb" >> ${file}
else
	echo "no build-versions.skb file found, automatic external dependency generation will not work"
fi
echo "MVN_GROUP_ID de.vandermeer" >> ${file}
echo "" >> ${file}

mkdir ../applications >& /dev/null
mkdir /tmp/logs >& /dev/null
mkdir /tmp/logs/skb >& /dev/null

exit 0
