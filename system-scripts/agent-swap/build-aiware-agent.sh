#!/bin/bash
source ./system-scripts/common.sh

echo "Building agent..."
cd "${GOPATH}${DEBUG_AIWARE_AGENT_PATH}"
make build-amd64-debug
cd -