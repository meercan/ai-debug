include .env

# Separator
TITLE:=----------------------------------------

define remote-command 
	ssh -i $(SSH_KEY_PATH) $(REMOTE_USER)@$(REMOTE_IP) -t "$1"
endef

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
.PHONY: build-new-agent archive-old-agent upload-agent start-agent agent-swap
build-new-agent:
	./system-scripts/agent-swap/build-new-agent.sh
archive-old-agent:
	./system-scripts/agent-swap/archive-old-agent.sh
upload-agent:
	./system-scripts/agent-swap/upload-agent.sh
start-agent:
	./system-scripts/agent-swap/start-agent.sh

agent-swap: archive-old-agent upload-agent start-agent
	@echo "Done!"