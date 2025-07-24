# Krkn-Visualize

This repo is very similar to [dittybopper](https://github.com/cloud-bulldozer/performance-dashboards/tree/master), this will be used to help users visualize their krkn runs as well as general data and performance of their clusters

# How to run 

```
./deploy.sh
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
