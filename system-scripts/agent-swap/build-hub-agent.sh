
#!/bin/bash
source ./system-scripts/common.sh

echo "Building agent..."
cd "${GOPATH}${DEBUG_HUB_AGENT_PATH}"
make build-amd64-debug
cd -
mkdir -p agent-binaries/builds
rsync -av --progress "${GOPATH}${DEBUG_HUB_AGENT_PATH}/dist/." ./agent-binaries/ --exclude=builds
rsync -av --progress "${GOPATH}${DEBUG_HUB_AGENT_PATH}/dist/builds/." ./agent-binaries/builds