#!/bin/bash

# load env vars
set -a
source ./ELinstall.env
set +a
IP_ADDR=$(ip -4 addr show "$NIC_TYPE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Cross-platform in-place sed (GNU/BSD)
sedi() { # usage: sedi 's|^KEY=.*$|KEY=VALUE|' file
  if sed --version &>/dev/null; then sed -i "$1" "$2"; else sed -i '' "$1" "$2"; fi
}

# Replace KEY=... if present, otherwise append KEY=VALUE
ensure_kv() { # KEY VALUE FILE
  local k="$1" v="$2" f="$3"
  [[ -f "$f" ]] || : > "$f"
  if grep -qE "^${k}=" "$f"; then
    sedi "s|^${k}=.*$|${k}=${v}|" "$f"
  else
    printf '\n%s=%s\n' "$k" "$v" >> "$f"
  fi
}

do_install() {
  set -e

# If docker, docker-compose and make are already installed via APT or another method, you can skip this step.\
  snap install docker
  sudo apt-get -y install make gettext rsyslog

# start syslog
  sudo systemctl enable rsyslog
  sudo systemctl start rsyslog
 
# Grant non-root user permissions to use docker
#  USER=`whoami`
#  groupadd docker
#  usermod -aG docker ${USER}
#  newgrp docker

#  Install node
  mkdir -p ~/Edgelake/node
  cd ~/Edgelake/node
  git clone https://github.com/edgelake/docker-compose
  cd docker-compose


# edit Makefile
#  sed -i 's/-it/-d/g' Makefile
  sedi "s/^export TAG ?= .*/export TAG ?= ${TAG}/" Makefile

# what type of node?
# Usage:
#   NODE_TYPE=master
#   NODE_TYPE=operator
#   NODE_TYPE=operator2
#   NODE_TYPE=query
  NODE_TYPE="${NODE_TYPE:-${1:-}}"
  if [[ -z "${NODE_TYPE}" ]]; then
    echo "ERROR: set NODE_TYPE to 'master', 'query', 'operator'  or 'operator2' (env or arg)." >&2
    exit 1
  fi
  
  h="$(hostname)"
  
  # forward syslog to anylog
  sudo tee /etc/rsyslog.d/60-custom-forwarding.conf > /dev/null <<EOF
template(name="MyCustomTemplate" type="string" string="<%PRI%>%TIMESTAMP% %HOSTNAME% %syslogtag% %msg%\\n")
*.* action(type="omfwd" target="${IP_ADDR}" port="32150" protocol="tcp" template="MyCustomTemplate")
EOF
  sudo systemctl restart rsyslog

for NODE_TYPE in master query operator operator2; do
  echo "Installing node: $NODE_TYPE"
  
  case "$NODE_TYPE" in
  master)
      ENV="docker-makefiles/master-configs/base_configs.env"
      AENV="docker-makefiles/master-configs/advance_configs.env"
      ensure_kv "NODE_NAME"     "${h}-master"            "$ENV"
      ensure_kv "COMPANY_NAME"  "${COMPANY_NAME}"        "$ENV"
      ensure_kv "LEDGER_CONN"   "${LEDGER_CONN}"         "$ENV"
      ensure_kv "TCP_BIND"      "${TCP_BIND}"            "$ENV"
      ensure_kv "REST_BIND"     "false"                  "$ENV"
      ensure_kv "BROKER_BIND"   "false"                  "$ENV"
      ensure_kv "NIC_TYPE"      "${NIC_TYPE}"            "$AENV"
      ensure_kv "MONITOR_NODES" "true"                   "$ENV"
      ensure_kv "STORE_MONITORING" "true"                "$ENV"
      
      make up EDGELAKE_TYPE="${NODE_TYPE}"
      ;;

  operator)
      ENV="docker-makefiles/operator-configs/base_configs.env"
      AENV="docker-makefiles/operator-configs/advance_configs.env"
      ensure_kv "NODE_NAME"     "${h}-operator"          "$ENV"
      ensure_kv "COMPANY_NAME"  "${COMPANY_NAME}"        "$ENV"
      ensure_kv "LEDGER_CONN"   "${LEDGER_CONN}"         "$ENV"
      ensure_kv "TCP_BIND"      "${TCP_BIND}"            "$ENV"
      ensure_kv "REST_BIND"     "false"                  "$ENV"
      ensure_kv "BROKER_BIND"   "false"                  "$ENV"
      ensure_kv "ANYLOG_BROKER_PORT" "32150"             "$ENV"
      ensure_kv "NIC_TYPE"      "${NIC_TYPE}"            "$AENV"
      ensure_kv "CLUSTER_NAME"  "${h}-operator-cluster"  "$ENV"
      ensure_kv "ENABLE_MQTT"   "true"                   "$ENV"
      ensure_kv "MQTT_BROKER"   "172.104.228.251"        "$ENV"
      ensure_kv "MONITOR_NODES" "true"                   "$ENV"
      ensure_kv "STORE_MONITORING" "true"                "$ENV"
      ensure_kv "SYSLOG_MONITORING" "true"               "$ENV"

      make up EDGELAKE_TYPE="${NODE_TYPE}"
      ;;

  operator2)
      cp -r docker-makefiles/operator-configs docker-makefiles/operator2-configs
      ENV="docker-makefiles/operator2-configs/base_configs.env"
      AENV="docker-makefiles/operator2-configs/advance_configs.env"
      ensure_kv "NODE_NAME"     "${h}-operator2"         "$ENV"
      ensure_kv "COMPANY_NAME"  "${COMPANY_NAME}"        "$ENV"
      ensure_kv "LEDGER_CONN"   "${LEDGER_CONN}"         "$ENV"
      ensure_kv "TCP_BIND"      "${TCP_BIND}"            "$ENV"
      ensure_kv "REST_BIND"     "false"                  "$ENV"
      ensure_kv "BROKER_BIND"   "false"                  "$ENV"
      ensure_kv "ANYLOG_SERVER_PORT" "32158"             "$ENV"
      ensure_kv "ANYLOG_REST_PORT"   "32159"             "$ENV"
      ensure_kv "NIC_TYPE"      "${NIC_TYPE}"            "$AENV"
      ensure_kv "CLUSTER_NAME"  "${h}-operator2-cluster" "$ENV"
      ensure_kv "ENABLE_MQTT"   "true"                   "$ENV"
      ensure_kv "MQTT_BROKER"   "172.104.228.251"        "$ENV"
      ensure_kv "MONITOR_NODES" "true"                   "$ENV"
      ensure_kv "STORE_MONITORING" "true"                "$ENV"
      ensure_kv "SYSLOG_MONITORING" "false"              "$ENV"

      make up EDGELAKE_TYPE="${NODE_TYPE}"
      ;;
     
  query)
      ENV="docker-makefiles/query-configs/base_configs.env"
      AENV="docker-makefiles/query-configs/advance_configs.env"
      ensure_kv "NODE_NAME"     "${h}-query"             "$ENV"
      ensure_kv "COMPANY_NAME"  "${COMPANY_NAME}"        "$ENV"
      ensure_kv "LEDGER_CONN"   "${LEDGER_CONN}"         "$ENV"
      ensure_kv "TCP_BIND"      "${TCP_BIND}"            "$ENV"
      ensure_kv "REST_BIND"     "false"                  "$ENV"
      ensure_kv "BROKER_BIND"   "false"                  "$ENV"
      ensure_kv "NIC_TYPE"      "${NIC_TYPE}"            "$AENV"
      ensure_kv "REMOTE_CLI"    "true"                   "$ENV"
      ensure_kv "MONITOR_NODES" "true"                   "$ENV"
      ensure_kv "STORE_MONITORING" "true"                "$ENV"
      
      make up EDGELAKE_TYPE="${NODE_TYPE}"
    
      # run remote gui and dashboard
      docker run -d -p 8000:8000 -p 3001:3001   --name gui-1   --restart unless-stopped   -e REACT_APP_API_URL=http://"$IP_ADDR":8000   anylogco/remote-gui:beta
      docker run -it -d -p 3000:3000 --restart unless-stopped -e DATASOURCE_URL=http://"$IP_ADDR":32349 --name grafana anylogco/oh-grafana:latest
      ;;

  *)
      echo "ERROR: Unknown NODE_TYPE '$NODE_TYPE' (expected 'master', 'query' or \ 'operator[2]')." >&2
      exit 1
      ;;
  esac

  echo "Node up for NODE_TYPE=$NODE_TYPE"
  done
}

do_uninstall () {

cd ~/Edgelake/node/docker-compose

for NODE_TYPE in master query operator operator2; do
  echo "Removing node: $NODE_TYPE"
  
  case "$NODE_TYPE" in
  master)
    make clean EDGELAKE_TYPE="${NODE_TYPE}"
    ;;

  operator)
    make clean EDGELAKE_TYPE="${NODE_TYPE}"
    ;;

  query)
    make clean EDGELAKE_TYPE="${NODE_TYPE}"
    docker kill gui-1
    docker rm gui-1
    docker rmi anylogco/remote-gui:beta      
    docker kill grafana
    docker rm grafana
    docker rmi anylogco/oh-grafana:latest
    ;;

  *)
    echo "ERROR: Unknown NODE_TYPE '$NODE_TYPE' (expected 'master', 'query' or \ 'operator[2]')." >&2
    exit 1
    ;;

  esac
  done  
}

case "$1" in
  install) do_install ;;
  uninstall) do_uninstall ;;
  *)
    echo "ERROR: Excpected $0 [install,uninstall]" >&2
    exit 1
  ;;

esac
