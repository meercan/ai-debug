## aiWARE Hub Developer Debug Kit

This is a developer toolkit for the aiWARE Hub that is intended to be used by developers to debug and test the aiWARE instance installations.

[See this document](https://steel-ventures.atlassian.net/wiki/spaces/~294271644/pages/2637660501/Setup+Local+Debugging+Env+-+Improved) for more information about why and how to use this toolkit.

## Prerequisites

- Set the empty environment variables in the `.env` file with your information

```
NGROK_AUTH_TOKEN=# your ngrok auth token
SSH_KEY_PATH=#ssh key for the remote machine
USER=#remote machine user
IP=#remote machine ip
```

## Features:

### 1. Debugging

A docker compose file that will start three containers that will serve the installation files and locally running `hub-controller` server.

**Structure:**
| URL | Connections | Local Resource |
|:------------------------------ | :---------------- | :---------------------------------------------- |
| ai-local-install.ngrok.io/hub/ | → ngrok → nginx → | installation scripts - `/hub-controller/scripts/` |
| ai-local-install.ngrok.io/dist/ | → ngrok → nginx → | aiware-agent binary - `/edge-agent/dist` |
|ai-local-hub.ngrok.io/hub/v1/ | → ngrok → | hub-controller - `localhost:9001` |

**Usage:**
| Available Command | Description |
| ----------------- | ------------------------------------ |
| `make start` | to spin up the containers. |
| `make stop` | will stop the containers. |
| `make clean` | will stop and remove the containers. |

---

### 2. aiware-agent swap

If you you are exclusively testing the functionality of the aiware-agent CLI you can just use this scripts and swap the aiware-agent binary.

| Script            | Description                                                                                                      |
| ----------------- | ---------------------------------------------------------------------------------------------------------------- |
| `make agent-swap` | This will swap compile a new aiware-agent from local files, then swap it with the aiware-agent in remote machine |

There are fragmets of scripts that constructs agent-swap scripts which are also available via Makefile, if you find it useful.
| Script | Description |
| ----------------- | ------------------------------------ |
| `make build-new-agent` | Build the agent from local edge-agent directory |
| `make archive-old-agent` | Remove or archives the aiware-agent binary in remote machine |
| `make upload-agent` | Upload locally build aiware-agent to remote machine |
| `make start-agent` | Start the new aiware-agent in remote machine |

---

### 3. Convenience scripts

| Script              | Description                                                                                                                  |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `make connect`      | this will connect to the remote machine                                                                                      |
| `make setup-remote` | this will move all scripts/remote listed below to the remote machine's home directory and install dependencies for debugging |
| `make clean-remote` | this will remove all scripts/remote from the remote machine                                                                  |

Following scripts can be run directly on the remote machine's root folder after running `make setup-remote`:

| Script             | Description                                                                         |
| ------------------ | ----------------------------------------------------------------------------------- |
| `wdocker.sh`       | Docker container monitor with only some info to make it fit in a terminal window    |
| `aiuninstall.sh`   | Uninstall "everything" aiware related                                               |
| `prepare-linux.sh` | Prepares a new Linux machine for aiware installation                                |
| `ailog.sh`         | Watch aiware-agent syslogs                                                          |
| `connect-psql.sh`  | Connects to the postgresql on localhost:5432. Installs postgresql if not installed. |
