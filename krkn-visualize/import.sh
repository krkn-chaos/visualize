set -e

function _usage {
  cat <<END

Deploys a mutable grafana pod with default dashboards for monitoring
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

function dash_import(){
  echo -e "\033[32mImporting dashboards...\033[0m"
  for dash in ${dash_import[@]}; do
    if [[ $dash =~ ^http ]]; then
      echo -e "Fetching remote dashboard $dash"
      dashfile="/tmp/$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)"
      curl -sS $dash -o $dashfile
    else
      echo -e "Using local dashboard ${dash}"
      dashfile=$dash
    fi
    dashboard=$(cat ${dashfile})
    echo "{\"dashboard\": ${dashboard}, \"overwrite\": true}" | \
    response_code=$(curl -Ss -XPOST -H "Content-Type: application/json" -H "Accept: application/json" -d@- \
    "http://admin:${GRAFANA_ADMIN_PASSWORD}@${visualize_route}/api/dashboards/db" -o /tmp/resp.txt)
    echo "response code: $response_code"
    if [[ $response_code == *'"status":"success"'* ]]; then
      echo ""
      echo -e "\033[31mFailed to import dashboard ${dash}\033[0m"
      cat  /tmp/resp.txt
      echo ""
      echo -e "\033[31mYou can find the above output in /tmp/resp.txt\033[0m"
      exit 1
    else
      echo -e "\033[32mImported dashboard ${dash}\033[0m"
    fi
  done
}

if [[ $k8s_cmd == "oc" ]]; then
  visualize_route=$(oc -n $namespace get route krkn-visualize -o jsonpath="{.spec.host}")
else
  visualize_route="localhost:3000"
fi

echo "visualize route: $visualize_route"
echo $GRAFANA_ADMIN_PASSWORD

dash_import

