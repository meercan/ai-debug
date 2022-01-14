#!/bin/bash -x
/usr/local/bin/aiware-agent-uninstall.sh
sudo rm -rf /etc/systemd/system/aiware-agent.service.env /opt/aiware
rm -f ~/.config/aiware-cli.yaml ~/.aiware/aiware-cli.yaml
docker rmi $(docker images -aq)