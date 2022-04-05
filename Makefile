include aiw-debug.env

# aiw-debug
# Start & stop aiw-debug server
.PHONY: start stop clean
start: debug-config-insert-sql hub-db-switch-debug-config
	@docker-compose --env-file aiw-debug.env up
stop:
	@docker-compose --env-file aiw-debug.env down
clean: 
	@docker-compose --env-file aiw-debug.env rm -fsv

# REMOTE HELPERS
# Connect, setup and clean your EC2
.PHONY: connect setup-remote clean-remote
setup-remote:
	./scripts/remote-helpers/setup-remote.sh
clean-remote:
	./scripts/remote-helpers/clean-remote.sh
connect:
	./scripts/remote-helpers/connect-remote.sh

# Build hub and aiware agents and move them in ./agent-binaries to prepare for agent debugging using `make start`
.PHONY: build-new-agents build-aiware-agent build-hub-agent
build-hub-agent:
	./scripts/agent-build/build-hub-agent.sh
build-aiware-agent:
	./scripts/agent-build/build-aiware-agent.sh
build-new-agents: build-aiware-agent build-hub-agent

# Actions for managing local Hub DB
.PHONY: hub-db-reset hub-db-insert-starter-data hub-db-switch-debug-config hub-db-switch-dev-config debug-config-insert-sql
# local hub DB postgres actions
hub-db-reset:
	./scripts/hub-db/hub-db-reset.sh
hub-db-switch-debug-config:
	./scripts/hub-db/hub-db-switch-debug-config.sh
hub-db-switch-dev-config:
	./scripts/hub-db/hub-db-switch-dev-config.sh
# This target is for generating a ngrok tunnel subdomain dynamically using the SESSION_NAME
# since NGROK tunnels are publick urls, we need to generate a subdomain dynamically for each user
# Following will generate a unique subdomain for current user and insert it to hub.config table when `make start` target is run
debug-config-insert-sql:
# Generate the INSERT scripts for URLS
	@sed "s/<hub-server-subdomain>/${HUB_SERVER_SUBDOMAIN}${SESSION_NAME}/" scripts/sql/hub-db-debug-config-urls-sql-template.txt | sed "s/<file-server-subdomain>/${FILE_SERVER_SUBDOMAIN}${SESSION_NAME}/g" > scripts/sql/hub-db-debug-config-urls.sql
# Place debug defaults to the main script file
	@cat scripts/sql/hub-db-debug-config-defaults.sql > scripts/sql/hub-db-debug-config.sql
# Append the INSERT scripts for URLS
	@cat scripts/sql/hub-db-debug-config-urls.sql >> scripts/sql/hub-db-debug-config.sql

# Get installation script for a small instance without running Hub UI 
.PHONY: hub-get-install-cmd
get-install-command:
	@echo "This command is not ready yet."
	./scripts/query/get-install-command.sh

# aiware agent swap helpers
.PHONY: archive-old-agent upload-agent start-agent agent-swap
# if you want to upload the agent instead of using make start command, you can utilized these commands
archive-old-agent:
	./scripts/agent-swap/archive-old-agent.sh
upload-agent:
	./scripts/agent-swap/upload-agent.sh
start-agent:
	./scripts/agent-swap/start-agent.sh
agent-swap: build-new-agents archive-old-agent upload-agent start-agent