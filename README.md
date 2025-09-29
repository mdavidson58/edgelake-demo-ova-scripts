# Edgelake Setup

This guide provides step-by-step instructions to access and configure Edgelake

---

## Table of Contents
- [Role Installations](#role-installations)
  - [Master](#master)
  - [Operator 1](#operator-1)
  - [Operator 2](#operator-2)
  - [Query](#query)
- [Notes](#notes)

---

## Role Installations
Clone the AnyLog docker-compose repository for each role:
```bash
cd /data
git clone https://github.com/anylog-co/docker-compose
cd docker-compose
```
### Master
#### Edit Makefile (step not needed if bug fixed)
```Makefile
TAG=latest-arm64
```
#### Edit docker-makefiles/master-configs/base_config.env
```base_config.env
LICENSE_KEY="<LICENSE_KEY>"
NODE_NAME=demo1-master
COMPANY_NAME=Cachengo
REST_BIND=false
TCP_BIND=true
LEDGER_CONN=<IP address of Master>:32048
```
---
### Operator 1
#### Edit Makefile (step not needed if bug fixed)
```Makefile
TAG=latest-arm64
```
#### Edit docker-makefiles/operator-configs/base_config.env
```base_config.env
LICENSE_KEY="<LICENSE_KEY>"
NODE_NAME=demo1-operator1
COMPANY_NAME=Cachengo
REST_BIND=false
TCP_BIND=true
CLUSTER_NAME=demo1-operator1-cluster
LEDGER_CONN=<IP address of Master>:32048
ENABLE_MQTT=true
MQTT_BROKER=172.104.228.251
```
---
### Operator 2
#### Edit Makefile (step not needed if bug fixed)
```Makefile
TAG=latest-arm64
```
#### Edit docker-makefiles/operator-configs/base_config.env
```base_config.env
LICENSE_KEY="<LICENSE_KEY>"
NODE_NAME=demo1-operator1
COMPANY_NAME=Cachengo
REST_BIND=false
TCP_BIND=true
CLUSTER_NAME=demo1-operator1-cluster
LEDGER_CONN=<IP address of Master>:32048
ENABLE_MQTT=true
MQTT_BROKER=172.104.228.251
```
---
### Query
#### Edit Makefile (step not needed if bug fixed)
```Makefile
TAG=latest-arm64
```
#### Edit docker-makefiles/query-configs/base_config.env
```base_config.env
LICENSE_KEY="<LICENSE_KEY>"
NODE_NAME=demo1-query
COMPANY_NAME=Cachengo
REST_BIND=false
TCP_BIND=true
LEDGER_CONN=<IP address of Master>:32048
```
#### Edit docker-makefiles/query-configs/advance_config.env (step not needed if bug fixed)
```advance_config.env
REMOTE_CLI=false
```
#### Run Remote GUI
```bash
sudo docker run -it \
  -p 8000:8000 \
  -p 3001:3001 \
  --name gui-1 \
  --restart unless-stopped \
  -e REACT_APP_API_URL=http://localhost:8000 \
  anylogco/remote-gui:beta
```
---
