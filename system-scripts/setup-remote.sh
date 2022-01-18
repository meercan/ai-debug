#!/bin/bash
source ./system-scripts/common.sh

setupRemote() {
    echo "Setting up the remote server for aiWARE debugging..."
    echo "------------------------------------------------------"
    echo "Moving scripts to the remote, in home folder at ${REMOTE_USER}@${REMOTE_IP}"
    scp -i ${SSH_KEY_PATH} -r ./scripts/remote/ ${REMOTE_USER}@${REMOTE_IP}:/tmp
    runRemoteCommand 'sudo cp -a /tmp/remote/. /home/ubuntu && rm -rf /tmp/remote'
    echo "------------------------------------------------------"
    echo "Installing dependencies:"
    echo "Running prepare-linux.sh in remote machine..."
    runRemoteCommand '/home/ubuntu/prepare-linux.sh'
    echo "Done!"
}

{
    echo "${TITLE}"
    verifyEnv
    setupRemote
}