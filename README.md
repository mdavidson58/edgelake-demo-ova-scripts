# EdgeLake Demo

This repository provides a reproducible demo environment for
**EdgeLake**, showcasing decentralized data orchestration at the edge
with AnyLog components. The demo spins up a set of containers (GUI,
Query node, Operators, and Master) and provides a quick way to explore
federated edge-to-cloud workflows.

------------------------------------------------------------------------

## 🚀 Getting Started

### Prerequisites

-   Ubuntu 22.04+ (Desktop or Server)
-   [Docker](https://docs.docker.com/engine/install/) and Docker Compose
-   Git (to clone this repository)

### Clone the Repository

``` bash
git clone https://github.com/<your-org>/<your-repo>.git
cd <your-repo>
```

------------------------------------------------------------------------

## ▶️ Starting the Demo

To launch all EdgeLake containers:

``` bash
./startup.sh
```

This script will: - Launch `gui-1` (UI for monitoring) - Start
`edgelake-demo-master` (control plane) - Start `edgelake-demo-query`
(query node) - Start `edgelake-demo-operator` and
`edgelake-demo-operator2` (data operators)

Once running: - **GUI**: http://localhost:3000 (Grafana/EdgeLake
dashboard) - **Query Node REST API**: http://localhost:32048 - **Master
REST API**: http://localhost:32049

------------------------------------------------------------------------

## 🔄 Health Check Script

If you want to ensure the demo containers are running (and restart them
if not):

``` bash
./check-containers.sh
```

This script checks for: - `gui-1` - `edgelake-demo-query` -
`edgelake-demo-operator` - `edgelake-demo-operator2` -
`edgelake-demmo-master`

If any are missing, it automatically reruns `./startup.sh`.

------------------------------------------------------------------------

## 📊 Exploring the Demo

-   Log into the **GUI** to see system metrics and dashboards.
-   Use the Query node to submit SQL-like queries against federated edge
    data.
-   Experiment with Operators to simulate distributed edge workloads.

------------------------------------------------------------------------

## 🛑 Stopping the Demo

To stop and remove all demo containers:

``` bash
docker compose down
```

------------------------------------------------------------------------

## 🧰 Troubleshooting

-   **Containers won't start**: Run `docker ps -a` to check logs.

-   **Ports already in use**: Ensure nothing else is bound to `3000`,
    `32048`, or `32049`.\

-   **Permission denied**: Make sure your user is in the `docker` group:

    ``` bash
    sudo usermod -aG docker $USER
    newgrp docker
    ```

------------------------------------------------------------------------

## 📖 Learn More

-   [AnyLog Documentation](https://anylog.co)
-   [EdgeLake Overview](https://anylog.co/edgelake)

------------------------------------------------------------------------

## 📝 License

This demo is provided for testing and educational purposes only.
