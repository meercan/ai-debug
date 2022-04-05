#!/bin/bash
source ./scripts/common.sh

connectRemote() {
    echo "Connecting ${REMOTE_USER}@${REMOTE_IP} using ${SSH_KEY_PATH}"
    echo "------------------------------------------------------"
    ssh -i "${SSH_KEY_PATH}" "${REMOTE_USER}"@"${REMOTE_IP}"
}

{
    echo "${TITLE}"
    verifyEnv
    connectRemote
}
