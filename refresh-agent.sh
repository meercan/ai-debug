DEBUG_AIWARE_AGENT_PATH=$GOPATH/src/github.com/veritone/realtime/services/edge-agent
DEBUG_AIWARE_SCRIPTS=$GOPATH/src/github.com/veritone/realtime/services/hub-controller/scripts/
DEBUG_AIWARE_DIST=$DEBUG_AIWARE_AGENT_PATH/dist
DEBUG_AIWARE_NGINX_HTML=/usr/share/nginx/html

SSH_KEY_PATH=~/dev/.ege_creds/hub-aiware.pem
USER=ubuntu
IP="10.24.3.93"
STOP_CMD="sudo systemctl stop aiware-agent"
START_CMD="sudo systemctl start aiware-agent"
COMMAND="$STOP_CMD && $START_CMD"

CMD_HANDLE_OLD="
cd /usr/local/bin \
if [ -L aiware-agent ]; then
	rm -f aiware-agent
else
	mv aiware-agent aiware-agent.archive
fi \
ln -s /home/ubuntu/aiware-agent \
cd -
"

debug_ai_replace_agent() {
	# 1. build new agent
	echo "Building agent..."
	cd $DEBUG_AIWARE_AGENT_PATH
	# make build --> with this you can build for all supported OSs
	make build-amd64-only
	cd -
	# 2. stop aiware-agent service
	echo "Stopping aiWARE Agent in host..."
	ssh -i $SSH_KEY_PATH $USER@$IP "sudo systemctl stop aiware-agent"
	# 3. scp new aiware-agent
	echo "Copying new agent binary..."
	scp -i $SSH_KEY_PATH "$DEBUG_AIWARE_DIST/aiware-agent-.-linux-amd64" $USER@$IP:aiware-agent
	ssh -i $SSH_KEY_PATH $USER@$IP $CMD_HANDLE_OLD
	# 4. start aiware-agent service
	echo "Starting aiWARE agent..."
	ssh -i $SSH_KEY_PATH $USER@$IP "sudo systemctl start aiware-agent"
	echo "Done!"
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

