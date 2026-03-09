set -euo pipefail

function _usage {
  cat <<END

Imports a specific rendered dashboard for monitoring
system submetrics during workload/benchmark runs

Usage: $(basename "${0}") [-c <kubectl_cmd>] [-n <namespace>] [-p <grafana_pwd>]

       $(basename "${0}") [-i <dash_path>]

       $(basename "${0}") [-d] [-n <namespace>]

  -c <kubectl_cmd>  : The (c)ommand to use for k8s admin (defaults to 'kubectl' for now)

  -n <namespace>    : The (n)amespace in which the Grafana instance was deployed
                      (defaults to 'krkn-visualize')

  -p <grafana_pass> : The (p)assword to configure for the Grafana admin user
                      (defaults to 'admin')

  -i <dash_path>    : (I)mport dashboard from given path. Using this flag will
                      bypass the deployment process and only do the import to an
                      already-running Grafana pod. Can be a local path or a remote
                      URL beginning with http.

  -l <grafana_url>  : (L)ocal grafana, pass the grafana url 

  -h                : Help

END
}

# Set defaults for command options
k8s_cmd='kubectl'
namespace='krkn-visualize'
grafana_default_pass=True
export PROMETHEUS_USER=internal
export GRAFANA_ADMIN_PASSWORD=admin

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
    i)
      dash_import+=(${OPTARG})
      ;;
    l)
      export LOCAL_GRAFANA_URL=${OPTARG}
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

function check_grafana_reachable() {
  local url="http://admin:${GRAFANA_ADMIN_PASSWORD}@${visualize_route}/api/health"
  local max_attempts=10
  local attempt=1
  echo -e "\033[32mChecking Grafana is reachable at ${visualize_route}...\033[0m"
  while [[ $attempt -le $max_attempts ]]; do
    if curl -sf "$url" -o /dev/null 2>/dev/null; then
      echo -e "\033[32mGrafana is reachable.\033[0m"
      return 0
    fi
    echo "Attempt ${attempt}/${max_attempts}: Grafana not yet reachable, retrying in 5s..."
    sleep 5
    ((attempt++))
  done
  echo -e "\033[31mERROR: Grafana is not reachable at ${visualize_route} after ${max_attempts} attempts.\033[0m" >&2
  exit 1
}

function dash_import(){
  if [[ ${#dash_import[@]} -eq 0 ]]; then
    echo -e "\033[31mERROR: No dashboards specified. Use -i <dash_path> to specify a dashboard.\033[0m" >&2
    _usage
    exit 1
  fi

  if [[ -z "${visualize_route:-}" ]]; then
    echo -e "\033[31mERROR: Could not determine Grafana route. Use -c oc, -l <url>, or ensure kubectl is configured.\033[0m" >&2
    exit 1
  fi

  check_grafana_reachable

  echo -e "\033[32mImporting dashboards...\033[0m"
  local import_errors=0
  for dash in "${dash_import[@]}"; do
    if [[ $dash =~ ^http ]]; then
      echo -e "Fetching remote dashboard $dash"
      dashfile="/tmp/$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8).json"
      if ! curl -fsSL "$dash" -o "$dashfile"; then
        echo -e "\033[31mERROR: Failed to download dashboard from ${dash}\033[0m" >&2
        ((import_errors++))
        continue
      fi
    else
      echo -e "Using local dashboard ${dash}"
      dashfile=$dash
    fi

    if [[ ! -f "${dashfile}" ]]; then
      echo -e "\033[31mERROR: Dashboard file not found: ${dashfile}\033[0m" >&2
      ((import_errors++))
      continue
    fi

    if ! dashboard=$(cat "${dashfile}"); then
      echo -e "\033[31mERROR: Failed to read dashboard file: ${dashfile}\033[0m" >&2
      ((import_errors++))
      continue
    fi

    http_code=$(echo "{\"dashboard\": ${dashboard}, \"overwrite\": true}" | \
      curl -Ss -XPOST \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d@- \
        -w "%{http_code}" \
        -o /tmp/resp.txt \
        "http://admin:${GRAFANA_ADMIN_PASSWORD}@${visualize_route}/api/dashboards/db")

    resp_status=$(python3 -c "import json,sys; d=json.load(open('/tmp/resp.txt')); print(d.get('status',''))" 2>/dev/null || echo "")

    if [[ "$http_code" == "200" ]] && [[ "$resp_status" == "success" ]]; then
      echo -e "\033[32mImported dashboard ${dash}\033[0m"
    else
      echo -e "\033[31mERROR: Failed to import dashboard ${dash} (HTTP ${http_code})\033[0m" >&2
      cat /tmp/resp.txt >&2
      echo "" >&2
      ((import_errors++))
    fi
  done

  if [[ $import_errors -gt 0 ]]; then
    echo -e "\033[31mERROR: ${import_errors} dashboard(s) failed to import.\033[0m" >&2
    exit 1
  fi
}

if [[ $k8s_cmd == "oc" ]]; then
  if ! command -v oc &>/dev/null; then
    echo -e "\033[31mERROR: 'oc' command not found. Please install the OpenShift CLI.\033[0m" >&2
    exit 1
  fi
  visualize_route=$(oc -n "$namespace" get route krkn-visualize -o jsonpath="{.spec.host}" 2>/dev/null || true)
  if [[ -z "${visualize_route}" ]]; then
    echo -e "\033[31mERROR: Could not retrieve route for krkn-visualize in namespace '${namespace}'.\033[0m" >&2
    exit 1
  fi
elif [[ -n "${LOCAL_GRAFANA_URL:-}" ]]; then
  visualize_route=$LOCAL_GRAFANA_URL
else
  if ! command -v kubectl &>/dev/null; then
    echo -e "\033[31mERROR: 'kubectl' command not found.\033[0m" >&2
    exit 1
  fi
  visualize_route="localhost:3000"
fi

echo "visualize route: $visualize_route"

dash_import

