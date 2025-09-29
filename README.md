---
lang: en
title: EdgeLake Demo -- Quick Start & Guide
viewport: width=device-width, initial-scale=1
---

::: wrap
::: hero
# ▶️ EdgeLake Demo -- Quick Start

A minimal, operator‑friendly guide to launching and exploring the
EdgeLake + AnyLog data fabric.

::: badges
[OVA boots → containers auto‑start]{.badge} [GUI, Query, Operator
x2]{.badge} [Local‑only endpoints]{.badge}
:::
:::

::: {.grid .two style="margin-top: 18px;"}
::: {.section .card}
## Automatic Start

When the OVA boots, all required containers are launched automatically.

::: {.callout .ok}
No action needed for a first‑run demo.
:::
:::

::: {.section .card}
## Manual Start (if needed)

Launch all EdgeLake containers with:

``` {#code-start}
Copycd ~/Edgelake
./ELstartup.sh
```

This starts:

-   **gui-1** -- Web UI for monitoring and data management
-   **edgelake-demo-master** -- Control plane
-   **edgelake-demo-query** -- Query node (SQL over AnyLog)
-   **edgelake-demo-operator** -- Data operator node
-   **edgelake-demo-operator2** -- Second data operator node
:::
:::

::: {.section .card}
## Service Endpoints

  Service                                                    Role                    Endpoint
  ---------------------------------------------------------- ----------------------- --------------------------------------------------------------------------------
  **GUI** [gui-1]{.pill}                                     Web UI                  [http://localhost:3000](http://localhost:3000){target="_blank" rel="noopener"}
  **Query Node REST** [edgelake-demo-query]{.pill}           SQL & Fabric Query      `localhost:32349`
  **Operator Node REST** [edgelake-demo-operator]{.pill}     Data Ingest / Control   `localhost:32149`
  **Operator2 Node REST** [edgelake-demo-operator2]{.pill}   Data Ingest / Control   `localhost:32159`

Using the GUI with a node

Open the GUI and insert the [IP:Port]{.kbd} of a Query or Operator node
in the Connection dialog, then click *Use*.
:::

::: {.grid .three}
::: {.section .card}
## Monitor

Track resources and health across nodes from the GUI dashboard.
:::

::: {.section .card}
## Add Data

Load JSON‑formatted data into an *operator* node via the GUI.
:::

::: {.section .card}
## SQL Query

Build and run SQL queries from the *query* node's GUI tool.
:::
:::

::: {.section .card}
## Blockchain Manager

Inspect blockchain metadata that underpins the data fabric.
:::

::: {.section .card}
## Default Demo Dataset

-   **Database:** `new_company`
-   **Table:** `rand_data`

::: callout
This table is pre‑populated via a cloud MQTT feed on first launch.
:::
:::

::: {.section .card}
## Add Your Own Data

1.  **Use the GUI (Operator node)**\
    Click *Add Data* and provide JSON‑formatted input.
2.  **Subscribe to a MQTT broker**\
    [MQTT Background Services
    (docs)](https://github.com/EdgeLake/edgelake.github.io/blob/mmain/docs/commmmands/background_services.md#subscribe-to-broker){target="_blank"
    rel="noopener"}
3.  **Insert via REST API**\
    [REST Insert
    Examples](https://github.com/EdgeLake/edgelake.github.io/blob/main/docs/examples/rest_examples.md#put-request){target="_blank"
    rel="noopener"}

::: {.callout .warn style="margin-top:10px;"}
Tip: Ensure you target an *operator* node for data insertion and the
*query* node for read/SQL workflows.
:::
:::

::: {.section .card}
## Documentation

-   [Getting
    Started](https://github.com/EdgeLake/edgelake.github.io/blob/main/docs/getting_started.md){target="_blank"
    rel="noopener"}
-   [Command
    Reference](https://github.com/EdgeLake/edgelake.github.io/docs/commmands){target="_blank"
    rel="noopener"} [external]{.pill}
:::

Pro tip: keep this page open on first boot. Use [Ctrl]{.kbd} + [L]{.kbd}
to focus the address bar quickly, and [Alt]{.kbd} + [←]{.kbd} to
navigate back.
:::
