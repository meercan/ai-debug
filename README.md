## aiWARE Hub Developer Debug Kit

This is a developer toolkit for the aiWARE Hub that is intended to be used by developers to debug and test the aiWARE instance installations.

[See this document](https://steel-ventures.atlassian.net/wiki/spaces/~294271644/pages/2637660501/Setup+Local+Debugging+Env+-+Improved) for more information about why and how to use this toolkit.

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

`aiware-agent-swap.sh` will swap the aiware-agent binary in a remote machine, like an EC2 instance running an aiWARE instance.
If you you are exclusively testing the functionality of the aiware-agent CLI you can just use this scripts and swap the aiware-agent binary.
**Usage:**

- Set the empty environment variables in the script with your information

```
SSH_KEY_PATH=#ssh key for the remote machine
USER=#remote machine user
IP=#remote machine ip
```

- Source this script in your shell. `source aiware-agent-swap.sh`
- Then either run `swap_aiware_agent()` function for a full swap or check out the script to see different function to use.

---

### 3. Convenience scripts

Clone this repository in the machine you are installing aiware instance and use the scripts in `/convenience-scripts` directory. Available scripts are:
| Script | Description |
| ----------------- | ------------------------------------ |
| `wdocker.sh` | Docker container monitor with only some info to make it fit in a terminal window |
| `aiuninstall.sh` | Uninstall "everything" aiware related |
| `prepare-linux.sh` | Prepares a new Linux machine for aiware installation |
| `ailog.sh` | Watch aiware-agent syslogs |
| `move-all-home.sh` | Moves all convenience scripts to the home directory for easy access |
| `connect-psql.sh` | Connects to the postgresql on localhost:5432. Installs postgresql if not installed. |
