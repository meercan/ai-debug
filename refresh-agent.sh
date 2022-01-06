DEBUG_AIWARE_AGENT_PATH=$GOPATH/src/github.com/veritone/realtime/services/edge-agent
DEBUG_AIWARE_SCRIPTS=$GOPATH/src/github.com/veritone/realtime/services/hub-controller/scripts/
DEBUG_AIWARE_DIST=$DEBUG_AIWARE_AGENT_PATH/dist
DEBUG_AIWARE_NGINX_HTML=/usr/share/nginx/html

SSH_KEY_PATH=~/dev/.ege_creds/hub-aiware.pem
USER=ubuntu
IP="10.24.0.144"
STOP_CMD="sudo systemctl stop aiware-agent"
START_CMD="sudo systemctl start aiware-agent"
COMMAND="$STOP_CMD && $START_CMD"

info() {
	echo "[INFO]: $1"
}

build_new_agent() {
	info "Building agent..."
	cd $DEBUG_AIWARE_AGENT_PATH
	# make build --> with this you can build for all supported OSs
	make build-prepare
	make build-amd64
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

# some trick I got online to watch changes in a directory and run a command when change happens
# https://superuser.com/questions/181517/how-to-execute-a-command-whenever-a-file-changes

# debug_ai_watch() {
# 	echo "Starting watching... Nothing will show up until the first change in watched directory"
# 	echo "Watching $DEBUG_AIWARE_AGENT_PATH"
# 	watch -n 1 \
# 	"\
# 	watch -t -g ls -lR $DEBUG_AIWARE_AGENT_PATH --full-time >/dev/null && \
# 	$COMMAND
# 	"
# }

