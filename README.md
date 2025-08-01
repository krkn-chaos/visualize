# Krkn-Visualize

This repo is very similar to [dittybopper](https://github.com/cloud-bulldozer/performance-dashboards/tree/master), this will be used to help users visualize their krkn runs as well as general data and performance of their clusters

# How to run 

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
- `-h`: Show help message and exit.

**Example Usage:**
```sh
./deploy.sh                       # Deploy Grafana in 'krkn-visualize' namespace with default password
./deploy.sh -n myns -p secret     # Deploy in 'myns' namespace with custom password
./deploy.sh -i dashboard.json     # Import dashboard to running Grafana
./deploy.sh -d                    # Delete deployment and namespace
```


## Manual Set Up for Krkn Dashboards
After the grafana dashboard has been created, you'll need to add in data sources to connect to your local elasic search 

You'll need to create 3 data sources connecting to krkn-telemetry, krkn-metrics and krkn-alerts indexes or the indexes you defined [here](https://github.com/krkn-chaos/krkn/blob/fff675f3dd7679a54e451fce7155371ee1a03474/config/config.yaml#L77-L79)
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
./import.sh

```