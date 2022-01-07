## aiWARE Hub Developer Debug Kit

This is a developer toolkit for the aiWARE Hub that is intended to be used by developers to debug and test the aiWARE instance installations.

[See this document](https://steel-ventures.atlassian.net/wiki/spaces/~294271644/pages/2637660501/Setup+Local+Debugging+Env+-+Improved) for more information about why and how to use this toolkit.

Currently, the toolkit is limited to the following features:

- A docker compose file that will start three containers that will serve the installation files and locally running `hub-controller` server.

**Structure:**
| Container | URL | Connections | Local Resource |
| :---------------------- | :------------------------------ | :---------------- | :---------------------------------------------- |
| ai-local-install-server | ai-local-install.ngrok.io/hub/ | → ngrok → nginx → | installation scripts - /hub-controller/scripts/ |
| ai-local-hub-controller | ai-local-install.ngrok.io/dist/ | → ngrok → nginx → | aiware-agent binary - /edge-agent/dist |
| ai-debug-nginx | ai-local-hub.ngrok.io/hub/v1/ | → ngrok → | hub-controller - localhost:9001 |

**Usage:**
| Available Command | Description |
| ----------------- | ------------------------------------ |
| `make start` | to spin up the containers. |
| `make stop` | will stop the containers. |
| `make clean` | will stop and remove the containers. |

- `aiware-agent-swap.sh` will swap the aiware-agent binary in a remote machine, like an EC2 instance running an aiWARE instance.
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
