#!/bin/bash
cd ~/Edgelake/master/docker-compose
make up EDGELAKE_TYPE=master
cd ~/Edgelake/operator/docker-compose
make up EDGELAKE_TYPE=operator
cd ~/Edgelake/operator2/docker-compose
make up EDGELAKE_TYPE=operator2
cd ~/Edgelake/query/docker-compose
make up EDGELAKE_TYPE=query
set -a
source ./ELinstall.env
set +a
IP_ADDR=$(ip -4 addr show "$NIC_TYPE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
docker run    -p 8000:8000 -p 3001:3001   --name gui-1   --restart unless-stopped   -e REACT_APP_API_URL=http://"$IP_ADDR":8000   anylogco/remote-gui:beta &
