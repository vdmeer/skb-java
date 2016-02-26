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
## @version    v2.1.0 build 160226 (26-Feb-16)

##
## call with sourced settings file
## requires MVN_GROUP_ID set for maven groudID
## requires MOD_FILE_BUILD_VERSIONS_BASH for automatic handling of external dependencies
##

if [ -z "$MVN_GROUP_ID" ]; then
	echo ""
	echo " ---> no groupId set, use \$MVN_GROUP_ID"
	exit 255
fi

if [ -z "$MOD_FILE_BUILD_VERSIONS_BASH" ]; then
	echo ""
	echo " ---> no build version file set, automatic generation of external dependencies will fail"
	echo "    --> use \$PROJECT_BUILD_VERSION_FILE when initializing the modules"
	exit 255
else
	source $MOD_FILE_BUILD_VERSIONS_BASH
fi

source $MOD_FILE_VERSION_BASH

echo -n "."
file_extension=".pom.xml"
gen_directory=$MOD_TARGET_MODULES_DIR/generated-poms
if [ ! -d $gen_directory ]; then
	mkdir $gen_directory
fi

echo -n "."
out_fn_fqpn=$gen_directory/$skb_module_artifact$file_extension
echo -n "" > $out_fn_fqpn

pom_fn_fqpn=$skb_module_directory/pom.xml

echo -n "."
cat $MOD_ETC_POMART_DIR/project-open.skb >> $out_fn_fqpn

	echo -n "."
	cat $MOD_ETC_POMART_DIR/modelVersion.skb >> $out_fn_fqpn
	echo "	<groupId>$MVN_GROUP_ID</groupId>" >> $out_fn_fqpn
	echo "	<artifactId>$skb_module_artifact</artifactId>" >> $out_fn_fqpn
	echo "	<version>$skb_module_version</version>" >> $out_fn_fqpn
	if [[ $skb_module_packaging && ${skb_module_packaging-_} ]]; then
		echo "	<packaging>$skb_module_packaging</packaging>" >> $out_fn_fqpn
	else
		echo "	<packaging>jar</packaging>" >> $out_fn_fqpn
	fi
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<name>$skb_module_name</name>" >> $out_fn_fqpn
	echo "	<url>$skb_module_url</url>" >> $out_fn_fqpn
	echo "	<description>$skb_module_description</description>" >> $out_fn_fqpn
	echo "	<inceptionYear>$skb_module_inceptionYear</inceptionYear>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<properties>" >> $out_fn_fqpn
		echo "		<maven.compiler.source>$skb_module_properties_compiler_source</maven.compiler.source>" >> $out_fn_fqpn
		echo "		<maven.compiler.target>$skb_module_properties_compiler_target</maven.compiler.target>" >> $out_fn_fqpn
		echo "		<project.build.sourceEncoding>$skb_module_properties_encoding</project.build.sourceEncoding>" >> $out_fn_fqpn
		echo "		<project.resources.sourceEncoding>$skb_module_properties_encoding</project.resources.sourceEncoding>" >> $out_fn_fqpn
		echo "		<encoding>$skb_module_properties_encoding</encoding>" >> $out_fn_fqpn
		echo "		<file.encoding>$skb_module_properties_encoding</file.encoding>" >> $out_fn_fqpn
		cat $MOD_ETC_POMART_DIR/properties.skb >> $out_fn_fqpn
	echo "	</properties>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	cat $MOD_ETC_POMART_DIR/licence.skb >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	cat $MOD_ETC_POMART_DIR/prerequisites.skb >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	cat $MOD_ETC_POMART_DIR/distributionManagement.skb >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<scm>" >> $out_fn_fqpn
		echo "		<developerConnection>$skb_module_scm_developerConnection</developerConnection>" >> $out_fn_fqpn
		echo "		<connection>$skb_module_scm_connection</connection>" >> $out_fn_fqpn
		echo "		<tag>$skb_module_artifact-$skb_module_version</tag>" >> $out_fn_fqpn
		echo "		<url>$skb_module_scm_url</url>" >> $out_fn_fqpn
	echo "	</scm>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<issueManagement>" >> $out_fn_fqpn
		echo "		<url>$skb_module_issueManagement_url</url>" >> $out_fn_fqpn
		echo "		<system>$skb_module_issueManagement_system</system>" >> $out_fn_fqpn
	echo "	</issueManagement>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<developers>" >> $out_fn_fqpn
		if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/developers.skb ] ; then
			cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/developers.skb >> $out_fn_fqpn
		fi
	echo "	</developers>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<contributors>" >> $out_fn_fqpn
		if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/contributors.skb ] ; then
			cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/contributors.skb >> $out_fn_fqpn
		fi
	echo "	</contributors>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<dependencies>" >> $out_fn_fqpn
		## first do all internal dependencies, we know the versions of them
		for intdep in $skb_module_internalDependencies
		do
			_v=`echo $intdep | sed -e 's/\-/_/g'`_version
			echo "		<dependency>" >> $out_fn_fqpn
			echo "			<groupId>$MVN_GROUP_ID</groupId>" >> $out_fn_fqpn
			echo "			<artifactId>$intdep</artifactId>" >> $out_fn_fqpn
			echo "			<version>${!_v}</version>" >> $out_fn_fqpn
			echo "		</dependency>" >> $out_fn_fqpn
		done
		## now do the external dependencies for compile scope
		if [ -n "$skb_module_externalDependencies_compile" ]; then
			for extdep in $skb_module_externalDependencies_compile
			do
				_dep_name=`echo $extdep | sed -e ':b; s/^\([^=]*\)*-/\1_/; tb;' -e 's/=$//' -e 's/^/_ed/'`
				if [ -z "$_dep_name" ]; then
					echo "external compile dependency not set: ${extdep}"
				else
					echo -n "."
					## get the actual content from the sourced variable
					## indirections work like this: http://www.tldp.org/LDP/abs/html/ivr.html
					eval _dep_name=\$$_dep_name
					_arr=$(echo $_dep_name | tr " " "\n")
					echo "		<dependency>" >> $out_fn_fqpn
					count=1
					for _elem in $_arr
					do
						if [ "$count" -eq 1 ]; then
							echo "			<groupId>$_elem</groupId>" >> $out_fn_fqpn
						fi
						if [ "$count" -eq 2 ]; then
							echo "			<artifactId>$_elem</artifactId>" >> $out_fn_fqpn
						fi
						if [ "$count" -eq 3 ]; then
							echo "			<version>$_elem</version>" >> $out_fn_fqpn
						fi
						count=$[$count + 1]
					done
					echo "		</dependency>" >> $out_fn_fqpn
				fi
			done
		fi
		## now do the external dependencies for test scope
		if [ -n "$skb_module_externalDependencies_test" ]; then
			for extdep in $skb_module_externalDependencies_test
			do
				_dep_name=`echo $extdep | sed -e ':b; s/^\([^=]*\)*-/\1_/; tb;' -e 's/=$//' -e 's/^/_ed/'`
				if [ -z "$_dep_name" ]; then
					echo "external test dependency not set: ${extdep}"
				else
					echo -n "."
					## get the actual content from the sourced variable
					## indirections work like this: http://www.tldp.org/LDP/abs/html/ivr.html
					eval _dep_name=\$$_dep_name
					_arr=$(echo $_dep_name | tr " " "\n")
					echo "		<dependency>" >> $out_fn_fqpn
					count=1
					for _elem in $_arr
					do
						if [ "$count" -eq 1 ]; then
							echo "			<groupId>$_elem</groupId>" >> $out_fn_fqpn
						fi
						if [ "$count" -eq 2 ]; then
							echo "			<artifactId>$_elem</artifactId>" >> $out_fn_fqpn
						fi
						if [ "$count" -eq 3 ]; then
							echo "			<version>$_elem</version>" >> $out_fn_fqpn
						fi
						count=$[$count + 1]
					done
					echo "			<scope>test</scope>" >> $out_fn_fqpn
					echo "		</dependency>" >> $out_fn_fqpn
				fi
			done
		fi
		if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/dependencies.skb ] ; then
			cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/dependencies.skb >> $out_fn_fqpn
		fi
	echo "	</dependencies>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	echo -n "."
	echo "	<build>" >> $out_fn_fqpn
	echo "		<plugins>" >> $out_fn_fqpn
	if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/plugins.skb ] ; then
		cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/plugins.skb >> $out_fn_fqpn
	fi

	#only add jar, javac and javadoc for non plugin projects
	if [ "$skb_module_packaging" != "maven-plugin" ]; then
		cat $MOD_ETC_POMART_DIR/plugin-jar.skb >> $out_fn_fqpn
		cat $MOD_ETC_POMART_DIR/plugin-compiler.skb >> $out_fn_fqpn

		echo -n "."
		if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/plugin-javadoc.skb ] ; then
			cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/plugin-javadoc.skb >> $out_fn_fqpn
		else
			cat $MOD_ETC_POMART_DIR/plugin-javadoc.skb >> $out_fn_fqpn
		fi

		echo -n "."
		cat $MOD_ETC_POMART_DIR/plugin-sourcejar.skb >> $out_fn_fqpn
	fi

	echo "		</plugins>" >> $out_fn_fqpn
	echo "	</build>" >> $out_fn_fqpn
	echo "" >> $out_fn_fqpn

	if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/reporting.skb ] ; then
		echo "	<reporting>" >> $out_fn_fqpn
		cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/reporting.skb >> $out_fn_fqpn
		echo "	</reporting>" >> $out_fn_fqpn
	fi
	echo "" >> $out_fn_fqpn

	echo -n "."
	if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/modules.skb ] ; then
		cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/modules.skb >> $out_fn_fqpn
		echo "" >> $out_fn_fqpn
	fi

	echo -n "."
	if [ -f $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/profiles.skb ] ; then
		cat $skb_module_directory/$MOD_MODULE_SETTINGS_DIR/profiles.skb >> $out_fn_fqpn
		echo "" >> $out_fn_fqpn
	fi

echo -n "."
cat $MOD_ETC_POMART_DIR/project-close.skb >> $out_fn_fqpn

echo -n "."
cat $out_fn_fqpn > $pom_fn_fqpn
echo -n " -> done"