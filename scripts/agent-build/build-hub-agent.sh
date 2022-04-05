#!/bin/bash
source ./scripts/common.sh

echo "Change directory to hub-agent"
cd "${GOPATH}${HUB_AGENT_PATH}" || exit 2

echo "Building hub-agent..."
make build-amd64-debug

echo "Change directory back to ${TOOL_NAME}"
cd - || exit 2
mkdir -p agent-binaries/builds
rsync -av --progress "${GOPATH}${HUB_AGENT_PATH}/dist/." ./agent-binaries/ --exclude=builds
rsync -av --progress "${GOPATH}${HUB_AGENT_PATH}/dist/builds/." ./agent-binaries/builds
