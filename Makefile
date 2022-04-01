.PHONY: start stop clean connect setup-remote clean-remote

start: 
	@docker-compose up
stop:
	@docker-compose down
clean: 
	@docker-compose rm -fsv

setup-remote:
	./system-scripts/setup-remote.sh
clean-remote:
	./system-scripts/clean-remote.sh
connect:
	./system-scripts/connect-remote.sh

# agent swap
.PHONY: build-new-agents archive-old-agent upload-agent start-agent agent-swap
build-hub-agent:
	./system-scripts/agent-swap/build-hub-agent.sh
build-aiware-agent:
	./system-scripts/agent-swap/build-aiware-agent.sh
build-new-agents: build-hub-agent build-aiware-agent

# if you want to upload the agent instead of using make start command, you can utilized these commands
archive-old-agent:
	./system-scripts/agent-swap/archive-old-agent.sh
upload-agent:
	./system-scripts/agent-swap/upload-agent.sh
start-agent:
	./system-scripts/agent-swap/start-agent.sh
agent-swap: build-new-agent archive-old-agent upload-agent start-agent

# local hub DB postgres actions
hub-db-reset:
	./scripts/local/hub-db-reset.sh
hub-db-insert-data:
	./scripts/local/insert-starter-data.sh
hub-db-switch-debug-config:
	./scripts/local/hub-db-switch-debug-config.sh
hub-db-switch-dev-config:
	./scripts/local/hub-db-switch-dev-config.sh

# convenience commands for getting authentication and install commands from Hub without using UI
hub-login:
	./scripts/local/hub-login.sh
get-install-command:
	./scripts/local/get-install-command.sh