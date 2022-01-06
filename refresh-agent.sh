# README
#
#
# Source this file in your terminal,
# then use function individually or
# use debug_ai_replace_agent to do everything at once.
#
#
# Important: Make sure your GOPATH is correct and set as env variable.
# Important: Add values to SSH_KEY_PATH, USER, IP below
#


DEBUG_AIWARE_AGENT_PATH=$GOPATH/src/github.com/veritone/realtime/services/edge-agent
DEBUG_AIWARE_SCRIPTS=$GOPATH/src/github.com/veritone/realtime/services/hub-controller/scripts/
DEBUG_AIWARE_DIST=$DEBUG_AIWARE_AGENT_PATH/dist
DEBUG_AIWARE_NGINX_HTML=/usr/share/nginx/html

SSH_KEY_PATH=#~/.ssh/hub-aiware.pem
USER=#ubuntu
IP=#10.24.0.144

info() {
    echo "[INFO]: $1"
}

build_new_agent() {
    info "Building agent..."
    cd $DEBUG_AIWARE_AGENT_PATH
    # make build --> with this you can build for all supported OSs
    make build-amd64-only
    cd -
}

upload_new_agent() {
    info "Starting uploading new aiware-agent binary..."
    scp -i $SSH_KEY_PATH "$DEBUG_AIWARE_DIST/aiware-agent-.-linux-amd64" "$USER@$IP":aiware-agent
}

manage_remote_commands() {
    
    info "Copying new agent binary..."
    ssh -i $SSH_KEY_PATH $USER@$IP -t "manage_agent_swap(){
echo '[INFO]: Stopping the current aiware-agent service...'
sudo systemctl stop aiware-agent
cd /usr/local/bin
if [ -L aiware-agent ]; then
echo '[INFO]: Removing aiware-agent...'
sudo rm -f aiware-agent
else
echo '[INFO]: Archiving aiware-agent...'
sudo mv aiware-agent aiware-agent.archive
fi
echo '[INFO]: Creating sym link for aiware-agent'
sudo ln -s /home/ubuntu/aiware-agent
cd -
echo '[INFO]: Operation is done. Ready to receive new aiware-agent...'
echo '[INFO]: Exiting from ssh tunnel...'
exit
    } && manage_agent_swap"
}

start_new_agent(){
    info "Starting new aiWARE agent..."
    ssh -i $SSH_KEY_PATH $USER@$IP "sudo systemctl start aiware-agent"
}

debug_ai_replace_agent() {
    build_new_agent
    manage_remote_commands
    upload_new_agent
    start_new_agent
    info "Done!"
}

