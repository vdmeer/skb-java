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
## Task that creates a POM file Module.
##
## @package    de.vandermeer.skb
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @copyright  2014-2015 Sven van der Meer
## @license    http://www.apache.org/licenses/LICENSE-2.0  Apache License, Version 2.0
## @version    v2.0.0 build 150729 (29-Jul-15)

##
## call with sourced settings file
## requires MVN_GROUP_ID set for maven groudID
##

if [ -z "$MVN_GROUP_ID" ]; then
	echo "no groupId set, use \$MVN_GROUP_ID"
	exit 255
fi

source $MOD_FILE_VERSION_BASH

file_extension=".pom.xml"
gen_directory=$MOD_TARGET_MODULES_DIR/generated-poms
if [ ! -d $gen_directory ]; then
	mkdir $gen_directory
fi

out_fn_fqpn=$gen_directory/$skb_module_artifact$file_extension
echo -n "" > $out_fn_fqpn

pom_fn_fqpn=$skb_module_directory/pom.xml

cat $MOD_ETC_POMART_DIR/project-open.xml >> $out_fn_fqpn
	cat $MOD_ETC_POMART_DIR/modelVersion.xml >> $out_fn_fqpn
	echo "	<groupId>$MVN_GROUP_ID</groupId>" >> $out_fn_fqpn
	echo "	<artifactId>$skb_module_artifact</artifactId>" >> $out_fn_fqpn
	echo "	<version>$skb_module_version</version>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<name>$skb_module_name</name>" >> $out_fn_fqpn
	echo "	<url>$skb_module_url</url>" >> $out_fn_fqpn
	echo "	<description>$skb_module_description</description>" >> $out_fn_fqpn
	echo "	<inceptionYear>$skb_module_inceptionYear</inceptionYear>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<properties>" >> $out_fn_fqpn
		echo "		<maven.compiler.source>$skb_module_properties_compiler_source</maven.compiler.source>" >> $out_fn_fqpn
		echo "		<maven.compiler.target>$skb_module_properties_compiler_target</maven.compiler.target>" >> $out_fn_fqpn
		echo "		<project.build.sourceEncoding>$skb_module_properties_encoding</project.build.sourceEncoding>" >> $out_fn_fqpn
		echo "		<project.resources.sourceEncoding>$skb_module_properties_encoding</project.resources.sourceEncoding>" >> $out_fn_fqpn
		echo "		<encoding>$skb_module_properties_encoding</encoding>" >> $out_fn_fqpn
		echo "		<file.encoding>$skb_module_properties_encoding</file.encoding>" >> $out_fn_fqpn
		cat $MOD_ETC_POMART_DIR/properties.xml >> $out_fn_fqpn
	echo "	</properties>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	cat $MOD_ETC_POMART_DIR/licence.xml >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	cat $MOD_ETC_POMART_DIR/prerequisites.xml >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	cat $MOD_ETC_POMART_DIR/distributionManagement.xml >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<scm>" >> $out_fn_fqpn
		echo "		<developerConnection>$skb_module_scm_developerConnection</developerConnection>" >> $out_fn_fqpn
		echo "		<connection>$skb_module_scm_connection</connection>" >> $out_fn_fqpn
		echo "		<tag>$skb_module_artifact-$skb_module_version</tag>" >> $out_fn_fqpn
		echo "		<url>$skb_module_scm_url</url>" >> $out_fn_fqpn
	echo "	</scm>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<issueManagement>" >> $out_fn_fqpn
		echo "		<url>$skb_module_issueManagement_url</url>" >> $out_fn_fqpn
		echo "		<system>$skb_module_issueManagement_system</system>" >> $out_fn_fqpn
	echo "	</issueManagement>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<developers>" >> $out_fn_fqpn
		if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-developers.xml ] ; then
			cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-developers.xml >> $out_fn_fqpn
		fi
	echo "	</developers>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<contributors>" >> $out_fn_fqpn
		if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-contributors.xml ] ; then
			cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-contributors.xml >> $out_fn_fqpn
		fi
	echo "	</contributors>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<dependencies>" >> $out_fn_fqpn
		for intdep in $skb_module_internalDependencies
		do
			_v=`echo $intdep | sed -e 's/\-/_/g'`_version
			echo "		<dependency>" >> $out_fn_fqpn
			echo "			<groupId>$MVN_GROUP_ID</groupId>" >> $out_fn_fqpn
			echo "			<artifactId>$intdep</artifactId>" >> $out_fn_fqpn
			echo "			<version>${!_v}</version>" >> $out_fn_fqpn
			echo "		</dependency>" >> $out_fn_fqpn
		done
		if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-dependencies.xml ] ; then
			cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-dependencies.xml >> $out_fn_fqpn
		fi
	echo "	</dependencies>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo "	<build>" >> $out_fn_fqpn
	echo "		<plugins>" >> $out_fn_fqpn
	if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-plugins.xml ] ; then
		cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$skb_module_artifact-plugins.xml >> $out_fn_fqpn
	fi
	cat $MOD_ETC_POMART_DIR/plugin-jar.xml >> $out_fn_fqpn
	cat $MOD_ETC_POMART_DIR/plugin-compiler.xml >> $out_fn_fqpn
	cat $MOD_ETC_POMART_DIR/plugin-javadoc.xml >> $out_fn_fqpn
	#cat $MOD_ETC_POMART_DIR/plugin-dependency.xml >> $out_fn_fqpn
	cat $MOD_ETC_POMART_DIR/plugin-sourcejar.xml >> $out_fn_fqpn
	echo "		</plugins>" >> $out_fn_fqpn
	echo "	</build>" >> $out_fn_fqpn

	if [[ $skb_module_packaging && ${skb_module_packaging-_} ]]; then
		echo "	<packaging>$skb_module_packaging</packaging>" >> $out_fn_fqpn
	else
		echo "	<packaging>jar</packaging>" >> $out_fn_fqpn
	fi

	if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$1-profiles.xml ] ; then
		cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/$1-profiles.xml >> $out_fn_fqpn
	fi

cat $MOD_ETC_POMART_DIR/project-close.xml >> $out_fn_fqpn

cat $out_fn_fqpn > $pom_fn_fqpn
