include aiw-debug.env

.PHONY: start stop clean

start: 
	@docker-compose --env-file aiw-debug.env up
stop:
	@docker-compose --env-file aiw-debug.env down
clean: 
	@docker-compose --env-file aiw-debug.env rm -fsv

.PHONY: connect setup-remote clean-remote
setup-remote:
	./system-scripts/setup-remote.sh
clean-remote:
	./system-scripts/clean-remote.sh
connect:
	./system-scripts/connect-remote.sh

# agent swap
.PHONY: build-new-agents build-aiware-agent build-hub-agent
build-hub-agent:
	./system-scripts/agent-swap/build-hub-agent.sh
build-aiware-agent:
	./system-scripts/agent-swap/build-aiware-agent.sh
build-new-agents: build-aiware-agent build-hub-agent

.PHONY: archive-old-agent upload-agent start-agent agent-swap
# if you want to upload the agent instead of using make start command, you can utilized these commands
archive-old-agent:
	./system-scripts/agent-swap/archive-old-agent.sh
upload-agent:
	./system-scripts/agent-swap/upload-agent.sh
start-agent:
	./system-scripts/agent-swap/start-agent.sh
agent-swap: build-new-agent archive-old-agent upload-agent start-agent

.PHONY: hub-db-reset hub-db-insert-data hub-db-switch-debug-config hub-db-switch-dev-config
# local hub DB postgres actions
hub-db-reset:
	./scripts/local/hub-db-reset.sh
hub-db-insert-data:
	./scripts/local/hub-db-insert-starter-data.sh
hub-db-switch-debug-config:
	./scripts/local/hub-db-switch-debug-config.sh
hub-db-switch-dev-config:
	./scripts/local/hub-db-switch-dev-config.sh

.PHONY: hub-login hub-get-install-cmd
# convenience commands for getting authentication and install commands from Hub without using UI
hub-login:
	./scripts/local/hub-login.sh
get-install-command:
	@echo "This command is not ready yet."
	./scripts/local/get-install-command.sh

sql:
# Generate the INSERT scripts for URLS
	@sed 's/%<hub-domain>%/${HUB_SERVER_SUBDOMAIN}${SESSION_NAME}/' scripts/sql/hub-db-debug-config-urls-sql-template.txt | \
	sed 's/%<get-aiware-domain>%/${FILE_SERVER_SUBDOMAIN}${SESSION_NAME}/' \
	> scripts/sql/hub-db-debug-config-urls.sql
# Place defaults to the main script file
	@cat scripts/sql/hub-db-debug-config-defaults.sql > scripts/sql/hub-db-debug-config.sql
# Append the INSERT scripts for URLS
	@cat scripts/sql/hub-db-debug-config-urls.sql >> scripts/sql/hub-db-debug-config.sql
