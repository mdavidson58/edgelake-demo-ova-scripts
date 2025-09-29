#!/bin/bash
cd ~/Edgelake/master/docker-compose
make up EDGELAKE_TYPE=master
cd ~/Edgelake/operator/docker-compose
make up EDGELAKE_TYPE=operator
cd ~/Edgelake/operator2/docker-compose
make up EDGELAKE_TYPE=operator2
cd ~/Edgelake/query/docker-compose
make up EDGELAKE_TYPE=query
docker run    -p 8000:8000 -p 3001:3001   --name gui-1   --restart unless-stopped   -e REACT_APP_API_URL=http://localhost:8000   anylogco/remote-gui:beta &
