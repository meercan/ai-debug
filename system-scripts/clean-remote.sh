#!/bin/bash
source ./system-scripts/common.sh

cleanRemote() {
    FILES_TO_REMOVE=`ls ./convenience-scripts | xargs`
    echo "Removing following files from remote machine:"
    echo "${FILES_TO_REMOVE}"
    runRemoteCommand "rm ${FILES_TO_REMOVE}"
}

{
    echo "${TITLE}"
    cleanRemote
}