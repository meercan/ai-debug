#!/bin/bash
source ./scripts/common.sh

echo "***************************************************"
echo "BEWARE: "
echo "Starting aiWARE agent will not work if there is not aiWARE agent running on the EC2 instance already."
echo "***************************************************"
echo "Attempting to start aiWARE agent service..."
runRemoteCommand "sudo systemctl start aiware-agent"
echo "Done!"
