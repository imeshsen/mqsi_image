#!/bin/bash

source /opt/ibm/ace-12/server/bin/mqsiprofile

export DISPLAY=:99
Xvfb :99 -ac &
sleep 2

echo "Executing mqsicreatebar $@"

exec mqsicreatebar "$@"
