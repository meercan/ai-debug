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
build-new-agents:
	./system-scripts/agent-swap/build-aiware-agent.sh
	./system-scripts/agent-swap/build-hub-agent.sh
archive-old-agent:
	./system-scripts/agent-swap/archive-old-agent.sh
upload-agent:
	./system-scripts/agent-swap/upload-agent.sh
start-agent:
	./system-scripts/agent-swap/start-agent.sh

agent-swap: build-new-agent archive-old-agent upload-agent start-agent

# BETA Commands
# don't use these yet
hub-db-reset:
	./scripts/local/hub-db-reset.sh
hub-db-insert-data:
	./scripts/local/insert-starter-data.sh
hub-login:
	./scripts/local/hub-login.sh
create-small-onprem:
	./scripts/local/create-small-onprem.sh