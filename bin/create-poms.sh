#!/bin/bash

echo "sourcing configuration"
source bin/source-bash

echo ""
echo "creating pom files for modules"
bin/modules -ma -t create-pom

exit 0
