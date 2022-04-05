#!/bin/bash
source ./scripts/common.sh

echo "Copying new agent binary..."
runRemoteCommand "manage_agent_swap(){
echo 'Stopping the current aiware-agent service...'
sudo systemctl stop aiware-agent
cd /usr/local/bin
if [ -L aiware-agent ]; then
echo 'Removing aiware-agent...'
sudo rm -f aiware-agent
else
echo 'Archiving aiware-agent...'
sudo mv aiware-agent aiware-agent.archive
fi
echo 'Creating sym link for aiware-agent'
sudo ln -s /home/ubuntu/aiware-agent
cd -
echo 'Operation is done. Ready to receive new aiware-agent...'
echo 'Exiting from ssh tunnel...'
exit
} && manage_agent_swap"
