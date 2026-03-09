#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# krkn-visualize deploy.sh
#
# Deploys a mutable Grafana pod with default dashboards for monitoring system
# submetrics during workload/benchmark runs.
#
# Command Line Options:
#   -c <kubectl_cmd>  : The (c)ommand to use for k8s admin (defaults to 'kubectl')
#   -n <namespace>    : The (n)amespace in which to deploy the Grafana instance
#                       (defaults to 'krkn-visualize')
#   -p <grafana_pass> : The (p)assword to configure for the Grafana admin user
#                       (defaults to 'admin')
#   -d                : (D)elete an existing deployment (namespace and Grafana)
#   -t <prometheus_url> : The (t)prometheus url to use for the Prometheus datasource
#   -b <prometheus_bearer_token> : The (b)earer token to use for the Prometheus datasource
#   -h                : Show this help message and exit
#
# Example Usage:
#   ./deploy.sh                       # Deploy Grafana in 'krkn-visualize' namespace with default password
#   ./deploy.sh -n myns -p secret     # Deploy in 'myns' namespace with custom password
#   ./deploy.sh -d                    # Delete deployment and namespace
# ------------------------------------------------------------------------------

set -euo pipefail

function _usage {
  cat <<END

Deploys a mutable grafana pod with default dashboards for monitoring
system submetrics during workload/benchmark runs

Usage: $(basename "${0}") [-c <kubectl_cmd>] [-n <namespace>] [-p <grafana_pwd>]

       $(basename "${0}") [-i <dash_path>]

       $(basename "${0}") [-d] [-n <namespace>]

  -c <kubectl_cmd>  : The (c)ommand to use for k8s admin (defaults to 'kubectl' for now)

  -n <namespace>    : The (n)amespace in which to deploy the Grafana instance
                      (defaults to 'krkn-visualize')

  -p <grafana_pass> : The (p)assword to configure for the Grafana admin user
                      (defaults to 'admin')

  -t <prometheus_url> : The (t)prometheus url to use for the Prometheus datasource

  -b <prometheus_bearer_token> : The (b)earer token to use for the Prometheus datasource
                      (defaults to '')

  -d                : (D)elete an existing deployment

  -h                : Help

END
}

# Set default template variables

export PROMETHEUS_USER=internal
export GRAFANA_ADMIN_PASSWORD=admin
export GRAFANA_URL="http://admin:${GRAFANA_ADMIN_PASSWORD}@localhost:3000"

export SYNCER_IMAGE=${SYNCER_IMAGE:-"quay.io/krkn-chaos/visualize-syncer:opensearch-latest"} # Syncer image
export GRAFANA_IMAGE=${GRAFANA_IMAGE:-"grafana/grafana:10.4.0"} # Grafana image
export GRAFANA_RENDERER_IMAGE=${GRAFANA_RENDERER_IMAGE:-"grafana/grafana-image-renderer:latest"} # Grafana renderer image

namespace_file="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/templates/krkn_visualize_ns.yaml.template"

# Set defaults for command options
k8s_cmd='kubectl'
namespace='krkn-visualize'
grafana_default_pass=True


# Capture and act on command options
while getopts ":c:m:n:p:i:dh" opt; do
  case ${opt} in
    c)
      k8s_cmd=${OPTARG}
      ;;
    n)
      namespace="${OPTARG}"
      ;;
    p)
      export GRAFANA_ADMIN_PASSWORD=${OPTARG}
      grafana_default_pass=False
      ;;
    d)
      delete=True
      ;;
    t)
      export PROMETHEUS_URL=${OPTARG}
      ;;
    b)
      export PROMETHEUS_BEARER=${OPTARG}
      ;;
    h)
      _usage
      exit 1
      ;;
    \?)
      echo -e "\033[32mERROR: Invalid option -${OPTARG}\033[0m" >&2
      _usage
      exit 1
      ;;
    :)
      echo -e "\033[32mERROR: Option -${OPTARG} requires an argument.\033[0m" >&2
      _usage
      exit 1
      ;;
  esac
done

# Validate required tools
if ! command -v "$k8s_cmd" &>/dev/null; then
  echo -e "\033[31mERROR: '${k8s_cmd}' command not found. Please install it before running this script.\033[0m" >&2
  exit 1
fi
if ! command -v envsubst &>/dev/null; then
  echo -e "\033[31mERROR: 'envsubst' command not found. Please install gettext.\033[0m" >&2
  exit 1
fi

# Other vars
if [[ $k8s_cmd == "oc" ]]; then
  export deploy_template="templates/krkn_visualize_oc.yaml.template"
else
  export deploy_template="templates/krkn-visualize.yaml.template"
fi

# Validate template files exist
if [[ ! -f "${namespace_file}" ]]; then
  echo -e "\033[31mERROR: Namespace template not found: ${namespace_file}\033[0m" >&2
  exit 1
fi
if [[ ! -f "${deploy_template}" ]]; then
  echo -e "\033[31mERROR: Deploy template not found: ${deploy_template}\033[0m" >&2
  exit 1
fi

python -m pip install pyfiglet --quiet || echo "Warning: pyfiglet install failed, skipping banner."
python -c "import pyfiglet; print(pyfiglet.figlet_format('krkn visualize'))" 2>/dev/null || true
echo "Using k8s command: $k8s_cmd"
echo "Using namespace: $namespace"
if [[ "${grafana_default_pass}" == "True" ]]; then
  echo "Using default grafana password: ${GRAFANA_ADMIN_PASSWORD}"
else
  echo "Using custom grafana password."
fi


# Get environment values
echo ""
echo -e "\033[32mGetting environment vars...\033[0m"
if [[ -n "${PROMETHEUS_URL:-}" ]]; then
  export PROMETHEUS_URL="${PROMETHEUS_URL}"
  export PROMETHEUS_BEARER="${PROMETHEUS_BEARER:-}"
elif [[ $k8s_cmd == "oc" ]]; then
  echo "Fetching Prometheus token via oc..."
  export PROMETHEUS_URL="https://prometheus-k8s.openshift-monitoring.svc.cluster.local:9091"
  export PROMETHEUS_BEARER
  PROMETHEUS_BEARER=$("$k8s_cmd" create token -n openshift-monitoring prometheus-k8s --duration 240h 2>/dev/null \
    || "$k8s_cmd" sa get-token -n openshift-monitoring prometheus-k8s 2>/dev/null \
    || "$k8s_cmd" sa new-token -n openshift-monitoring prometheus-k8s 2>/dev/null \
    || true)
  if [[ -z "${PROMETHEUS_BEARER}" ]]; then
    echo -e "\033[31mWARNING: Could not obtain Prometheus bearer token. Prometheus datasource may not work.\033[0m" >&2
  fi
else
  prometheus_ns=$("$k8s_cmd" get ns | grep monitoring | awk '{print $1}' || true)
  if [[ -z "${prometheus_ns}" ]]; then
    echo -e "\033[31mWARNING: Could not find a monitoring namespace. Prometheus datasource may not be configured.\033[0m" >&2
    export PROMETHEUS_URL=""
  else
    pod_name="prometheus-operated"
    prom_ip=$("$k8s_cmd" get endpoints -n "$prometheus_ns" "$pod_name" -o jsonpath="{.subsets[0].addresses[0].ip}" 2>/dev/null || true)
    prom_port=$("$k8s_cmd" get endpoints -n "$prometheus_ns" "$pod_name" -o jsonpath="{.subsets[0].ports[0].port}" 2>/dev/null || true)
    if [[ -z "${prom_ip}" ]] || [[ -z "${prom_port}" ]]; then
      echo -e "\033[31mWARNING: Could not resolve Prometheus endpoint in namespace '${prometheus_ns}'.\033[0m" >&2
      export PROMETHEUS_URL=""
    else
      export PROMETHEUS_URL="http://${prom_ip}:${prom_port}"
    fi
  fi
fi
echo "Prometheus URL is: ${PROMETHEUS_URL:-<not set>}"

function namespace() {
  # Create namespace
  $k8s_cmd "$1" -f "$namespace_file"
}

function grafana() {

  echo "es url: $ES_URL"
  envsubst < ${deploy_template} | $k8s_cmd "$1" -n "$namespace" -f -
  if [[ ! $delete ]]; then
    echo ""
    echo -e "\033[32mWaiting for krkn-visualize deployment to be available...\033[0m"
    if $k8s_cmd wait --for=condition=available -n $namespace deployment/krkn-visualize --timeout=60s; then
      return 0
    else
      $k8s_cmd get pods -n $namespace
      $k8s_cmd get deploy -n $namespace
      $k8s_cmd logs -l app=krkn-visualize --max-log-requests=100 -n $namespace --all-containers=true
      exit 1
    fi
  fi
}

if [[ $delete ]]; then
  echo ""
  echo -e "\033[32mDeleting Grafana...\033[0m"
  grafana "delete"
  echo ""
  echo -e "\033[32mDeleting namespace...\033[0m"
  namespace "delete"
  echo ""
  echo -e "\033[32mDeployment deleted!\033[0m"
else
  echo ""
  echo -e "\033[32mCreating namespace...\033[0m"
  # delete the namespace if it already exists to make sure the latest version of the dashboards are deployed and also to support the case where user wants to redeploy krkn-visualize without having to delete the namespace manually
  if [[ $($k8s_cmd get namespaces | grep -w $namespace) ]]; then
    echo "Looks like the namespace $namespace already exists, deleting it"
    namespace "delete"
  fi
  namespace "create"
  echo ""
  echo -e "\033[32mDeploying Grafana...\033[0m"
  grafana "apply"
  if [[ $k8s_cmd != "oc" ]]; then
    echo "Port forwarding to localhost:3000..."
    "$k8s_cmd" -n "$namespace" port-forward service/krkn-visualize 3000 &
    pf_pid=$!
    visualize_route="localhost:3000"
    # Wait for port-forward to be ready
    max_wait=30
    elapsed=0
    until curl -sf "http://admin:${GRAFANA_ADMIN_PASSWORD}@${visualize_route}/api/health" -o /dev/null 2>/dev/null; do
      if [[ $elapsed -ge $max_wait ]]; then
        echo -e "\033[31mERROR: Grafana did not become reachable on ${visualize_route} within ${max_wait}s.\033[0m" >&2
        kill "$pf_pid" 2>/dev/null || true
        exit 1
      fi
      sleep 2
      ((elapsed+=2))
    done
  else
    echo "Getting route for oc..."
    visualize_route=$("$k8s_cmd" -n "$namespace" get route krkn-visualize -o jsonpath="{.spec.host}" 2>/dev/null || true)
    if [[ -z "${visualize_route}" ]]; then
      echo -e "\033[31mERROR: Could not retrieve route for krkn-visualize in namespace '${namespace}'.\033[0m" >&2
      exit 1
    fi
  fi

  echo "visualize route: $visualize_route"
  echo "You can access the Grafana instance at http://${visualize_route}"
fi