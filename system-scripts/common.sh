#!/bin/bash
source .env

export TITLE="#---------------------# aiWARE Debug #---------------------#"

verifyEnv() {
    if [ "${REMOTE_IP}" == "" ]; then echo "!!! Set REMOTE_IP in .env file" && echo && exit 1; fi
    if [ "${REMOTE_USER}" == "" ]; then echo "!!! Set REMOTE_USER in .env file" && echo && exit 1; fi
    if [ "${SSH_KEY_PATH}" == "" ]; then echo "!!! Set SSH_KEY_PATH in .env file" && echo && exit 1; fi
    echo "All env variables are set! Continuing..."
}

runRemoteCommand() {
    ssh -i "${SSH_KEY_PATH}" "${REMOTE_USER}@${REMOTE_IP}" -t "${1}"
}
