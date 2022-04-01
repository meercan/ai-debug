#!/bin/bash
source ./system-scripts/common.sh

cleanRemote() {
    FILES_TO_REMOVE=$(ls ./scripts/remote | xargs)
    echo "Removing following files from remote machine:"
    echo "${FILES_TO_REMOVE}"
    runRemoteCommand "rm ${FILES_TO_REMOVE}"
}

{
    echo "${TITLE}"
    cleanRemote
}
