#!/bin/bash
source ./system-scripts/common.sh

echo "Starting uploading new aiware-agent binary..."
scp -i "${SSH_KEY_PATH}" "${GOPATH}${AIW_DIST}/aiware-agent-.-linux-amd64" "${REMOTE_USER}"@"${REMOTE_IP}":aiware-agent
