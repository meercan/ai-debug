#!/bin/bash
source ./system-scripts/common.sh

echo "Starting new aiWARE agent..."
runRemoteCommand "sudo systemctl start aiware-agent"