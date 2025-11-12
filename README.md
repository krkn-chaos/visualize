# Krkn-Visualize

This repo is very similar to [dittybopper](https://github.com/cloud-bulldozer/performance-dashboards/tree/master), this will be used to help users visualize their krkn runs as well as general data and performance of their clusters

# How to run 
```
cd krkn-visualize
export ES_URL=<elasticsearch url>
export ES_USERNAME=<elasticsearch username>
export ES_PASSWORD=<elasticsearch password>
```


NOTE: The deploy with the elastic search variables set will create the elasticsearch data sources but the index patterns 

On Kubernetes Cluster
```
./deploy.sh
```

On OpenShift Cluster
```
./deploy.sh -c oc
```

**Deploys a mutable Grafana pod with default dashboards for monitoring system submetrics during workload/benchmark runs.**

**Options:**
- `-c <kubectl_cmd>`: The command to use for k8s admin (defaults to `kubectl`).
- `-n <namespace>`: The namespace in which to deploy the Grafana instance (defaults to `krkn-visualize`).
- `-p <grafana_pass>`: The password to configure for the Grafana admin user (defaults to `admin`).
- `-i <dash_path>`: Import dashboard from given path. Using this flag will bypass the deployment process and only do the import to an already-running Grafana pod. Can be a local path or a remote URL beginning with http.
- `-d`: Delete an existing deployment (namespace and Grafana).
- `-t`: The (t)prometheus url to use for the Prometheus datasource (if openshift will use https://prometheus-k8s.openshift-monitoring.svc.cluster.local:9091, if kuberenetes will use prometheus url in pod: prometheus-operated in `monitoring` namespace)
- `b`: The (b)earer token to use for the Prometheus datasource (if openshift will auto create a new token, don't need for prometheus in kubernetes )
- `-h`: Show help message and exit.

**Example Usage:**
```sh
./deploy.sh                       # Deploy Grafana in 'krkn-visualize' namespace with default password
./deploy.sh -n myns -p secret     # Deploy in 'myns' namespace with custom password
./deploy.sh -i dashboard.json     # Import dashboard to running Grafana
./deploy.sh -d                    # Delete deployment and namespace
```


## Manual Prometheus Set up of Datasource
To manually set up a Prometheus datasource in Grafana using a Prometheus URL and bearer token from OpenShift:

1. **Retrieve Prometheus URL and Bearer Token from OpenShift:**
   - Get the Prometheus route URL (for OpenShift monitoring, often called `prometheus-k8s`):
     ```sh
     oc get route prometheus-k8s -n openshift-monitoring -o jsonpath="https://{.spec.host}{'\n'}"
     ```
   - Get the token for a user or service account with permission to access Prometheus:
     ```sh
     oc sa get-token prometheus-k8s -n openshift-monitoring
     ```
     Alternatively, log in as a user with sufficient rights and run:
     ```sh
     oc whoami --show-token
     ```

2. **Add Prometheus Data Source in Grafana:**
   1. Log into Grafana as an admin user.
   2. In the sidebar, hover over the gear icon (⚙️) and select **Data Sources**.
   3. Click **Add data source**.
   4. Select **Prometheus** as the data source type.
   5. In the **HTTP** section, set the **URL** to your OpenShift Prometheus URL (from step 1, including `https://`).
   6. In **Auth** section:
      - Enable **With Credentials**.
      - Set **Auth Type** to **Bearer Token** (if shown).
      - If no dedicated field:
        - Expand the **HTTP Headers** section.
        - Add a custom header:
          - Name: `Authorization`
          - Value: `Bearer <PASTE-YOUR-TOKEN-HERE>`
   7. (Optional, but recommended) Set **Skip TLS Verify** to `true` if using self-signed OpenShift certs, or add the OpenShift CA cert.
   8. Click **Save & Test** at the bottom of the page to verify the connection.

**Tip:**  
If Grafana is running as a pod in your OpenShift cluster, you can mount a service account token file into the container for automated rotation (advanced; see OpenShift docs).

**References:**
- [OpenShift documentation: Prometheus](https://docs.openshift.com/container-platform/latest/monitoring/configuring-the-monitoring-stack.html)
- [Grafana documentation: Add Prometheus data source](https://grafana.com/docs/grafana/latest/datasources/prometheus/)



## Manual Set Up for Krkn Dashboards
After the grafana dashboard has been created, you'll need to add in data sources to connect to your local elasic search 

You'll need to create 3 data sources connecting to krkn-telemetry, krkn-metrics and krkn-alerts indexes or the indexes you defined [here](https://github.com/krkn-chaos/krkn/blob/main/config/config.yaml#L75-L77)
1. Log in as admin user
2. Find Configuration tab and click Data Sources
3. Click new data source
4. Add a name for the data source, be sure the name contains "Telemetry", "Metrics", and "Alerts" for the corresponding indexes so our dashboards can properly find them
5. Add the URL of your elasticsearch
6. Add authentication into elastic search
7. Give the corresponding index name you're configuring under Elasticsearch details
8. Remove the @ from before the timestamp field (Alerts needs created_at)
9. Save & test
10. Repeat for each index

# Adding a New Dashboard
1. Create folder under assets 
2. Create panels.libsonnet, queries.libsonnet, and variables.libsonnet under the newly created folder
3. Create jsonnet file under General or if its specific to kubernetes, k8s
4. Run `make`

## Import Dashboard After Grafana Creation
Edit import file to point to newly created rendered json. Note the grafana version needs to match the grafannot listed [here](https://github.com/krkn-chaos/visualize/blob/main/templates/jsonnetfile.lock.json#L18), will hit loading errors if not 
```sh
cd krkn-visualize
./import.sh -i ../rendered/<folder>/<dashboard_name>.json

```
**Options:**
- `-c <kubectl_cmd>`: The command to use for k8s admin (defaults to `kubectl`).
- `-n <namespace>`: The namespace in which to deploy the Grafana instance (defaults to `krkn-visualize`).
- `-p <grafana_pass>`: The password to configure for the Grafana admin user (defaults to `admin`).
- `-i <dash_path>`: Import dashboard from given path. Using this flag will bypass the deployment process and only do the import to an already-running Grafana pod.
- `-l <grafana_url>`: Local grafana url to use when importing the dashboards, won't execute kubernetes commands
- `-h`: Show help message and exit.