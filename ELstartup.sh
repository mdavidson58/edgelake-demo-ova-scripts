
#!/bin/bash
# Start Edgelake Services
cd ~/Edgelake/node/docker-compose
make up EDGELAKE_TYPE=master
make up EDGELAKE_TYPE=operator
make up EDGELAKE_TYPE=operator2
make up EDGELAKE_TYPE=query

# Load env variables
set -a
source ~/Edgelake/ELinstall.env
set +a
IP_ADDR=$(ip -4 addr show "$NIC_TYPE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# start sample grafana dashboard
docker run -it -d -p 3000:3000 --restart unless-stopped -e DATASOURCE_URL=http://"$IP_ADDR":32349 --name grafana anylogco/oh-grafana:latest
# start new EL gui
docker run -d -p 8000:8000 -p 3001:3001   --name gui-1   --restart unless-stopped   -e REACT_APP_API_URL=http://"$IP_ADDR":8000   anylogco/remote-gui:beta
