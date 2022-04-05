## aiWARE Hub Developer Debug Kit

This is intended to be used to:

- debug and test the aiWARE instance installations
- debug and test **aiware-agent** and/or **hub-agent**
- debug and test installation scripts under `hub-controller/scripts` (ex. install.sh that is used for installing aiware-agen)
- swap aiware-agent in an EC2 with local build
- load **convenience scripts** to the EC2 that holds test environment
- reset local `aiware-postgres` DB container and re-populate it with a starter data

---

**Security Note:**
Before anything, run `git update-index --skip-worktree aiw-debug.env` in this repo to instruct git not to track any changes in the env file so that you don't push your personal info or secrets to Github.

---

Here is what you get:

[See this document](https://steel-ventures.atlassian.net/wiki/spaces/~294271644/pages/2637660501/Setup+Local+Debugging+Env+-+Improved) for more information about why and how to use this toolkit.

![f7c49a5d-aa25-4c0b-b416-1ad728f507cd](https://user-images.githubusercontent.com/89795043/149984435-d7e83465-03ea-460c-802b-721b36cc20bc.png)

## Prerequisites

- Set the empty environment variables in the `aiw-debug.env` file with your information

```sh
REMOTE_IP=#--------------EC2 IP that you are planning to install th aiWARE instance in
REMOTE_USER=#------------Add EC2 user name here (ex. ubuntu for Ubuntu, ec2-user for RHEL)
SSH_KEY_PATH=#-----------Add path to ssh key for the EC2
SESSION_NAME=#-----------Session name for creating unique NGROK tunnel subdomain
NGROK_AUTH_TOKEN=#-------NGROK auth token (Veritone has business account, login NGROK dashboard with your email and paste auth token here)
DB_CONTAINER_NAME=#------Specify your Hub DB container name (ex. aiware-postgres)
```

## Features:

### 1. Debugging

A docker compose file that will start three containers that will serve the installation files and locally running `hub-controller` server.

| Make targets                 | Description                                                                                                                                                              |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `start`                      | start aiw-debug                                                                                                                                                          |
| `stop`                       | stop the aiw-debug                                                                                                                                                       |
| `clean`                      | stop and remove aiw-debug                                                                                                                                                |
| `connect`                    | connect to the EC2 instance using the `REMOTE_IP`, `REMOTE_USER`, `SSH_KEY_PATH` env variables in aiw-debug.env                                                          |
| `setup-remote`               | move convenience-scripts to the EC2 and install docker in EC2                                                                                                            |
| `clean-remote`               | remove all convenience-scripts in the EC2                                                                                                                                |
| `build-hub-agent`            | build hub-agent and move debug binaries in `agent-binaries` directory to serve                                                                                           |
| `build-aiware-agent`         | build aiware-agent and move debug binaries in `agent-binaries` directory to serve                                                                                        |
| `build-new-agents`           | build aiware and hub agents and move debug binaries in `agent-binaries` directory to serve                                                                               |
| `hub-db-reset`               | reset and re-populate Hub DB with starter data using the container name specified in aiw-debug.env file for DB container                                                 |
| `hub-db-switch-debug-config` | change hub.config table to hold debug configurations (required when using aiw-debug tool)                                                                                |
| `hub-db-switch-dev-config`   | change hub.config table to hold development configurations (default configuration for making a veritone-managed aiware instance installation from local in veritone AWS) |
| `get-install-command`        | without running Hub UI, get an installation script for a small aiware instance from the local hub-controller                                                             |

**Setting up:**

1. Run `make start` to start **aiw-debug** server
1. Run local `hub-controller`
1. Run `make setup-remote` to move convenience scripts to EC2 and install docker in EC2
1. Run `make connect` to connect your EC2

**Testing installation scripts:**

1. [_skip if you have an installation command for an instance_] Run `make get-install-command` to create a small instance via `hub-controller` and get installation command w/o UI
1. Paste and run the installation script (make sure `docker` is available)
   This will install the created instance using your local files.

**Testing aiware/hub agents:**
After setting up steps,

1. Run `make build-new-agents` to build new aiware- and hub- agents
1. [_skip if you have an installation command for an instance_] Run `make get-install-command` to create a small instance via `hub-controller` and get installation command w/o UI
1. Paste and run the installation script (make sure `docker` is available)
   This will install the aiware and hub agents from your local builds

---

### 2. aiware-agent swap

If you you are exclusively testing the functionality of the aiware-agent CLI you can just use this scripts and swap the aiware-agent binary.

| Script            | Description                                                                                                      |
| ----------------- | ---------------------------------------------------------------------------------------------------------------- |
| `make agent-swap` | This will swap compile a new aiware-agent from local files, then swap it with the aiware-agent in remote machine |

There are fragmets of scripts that constructs agent-swap scripts which are also available via Makefile, if you find it useful.
| Script | Description |
| ----------------- | ------------------------------------ |
| `make build-new-agents` | Build the agent from local edge-agent directory |
| `make archive-old-agent` | Remove or archives the aiware-agent binary in remote machine |
| `make upload-agent` | Upload locally build aiware-agent to remote machine |
| `make start-agent` | Start the new aiware-agent in remote machine |

Note that these will not work if there is no aiware-agent installed in the EC2 instance already.

---

### 3. Convenience scripts

Following scripts can be run directly on the remote machine's root folder after running `make setup-remote`:

| Script             | Description                                                                         |
| ------------------ | ----------------------------------------------------------------------------------- |
| `wdocker.sh`       | Docker container monitor with only some info to make it fit in a terminal window    |
| `aiuninstall.sh`   | Uninstall "everything" aiware related                                               |
| `prepare-linux.sh` | Prepares a new Linux machine for aiware installation                                |
| `ailog.sh`         | Watch aiware-agent syslogs                                                          |
| `connect-psql.sh`  | Connects to the postgresql on localhost:5432. Installs postgresql if not installed. |

---

### Structure details:

| URL                                      | Connections       | Local Resource                                    |
| :--------------------------------------- | :---------------- | :------------------------------------------------ |
| <hub-server-subdomain>.ngrok.io/hub/     | → ngrok → nginx → | installation scripts - `/hub-controller/scripts/` |
| <file-server-subdomain>.ngrok.io/dist/   | → ngrok → nginx → | aiware-agent binary - `/edge-agent/dist`          |
| <file-server-subdomain>.ngrok.io/hub/v1/ | → ngrok →         | hub-controller - `localhost:9001`                 |
