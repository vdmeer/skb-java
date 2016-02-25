#!/bin/bash

echo "sourcing configuration"
source bin/source-bash

echo ""
echo "initializing modules"
bin/modules -i

exit 0
