
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

visualize_route=$(oc -n krkn-visualize get route krkn-visualize -o jsonpath="{.spec.host}")
#visualize_route="127.0.0.1:3000"
echo "visualize route: $visualize_route"

GRAFANA_ADMIN_PASSWORD=$(kubectl --namespace monitoring get secrets kind-prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo || echo "admin")
GRAFANA_ADMIN_PASSWORD="admin"
echo $GRAFANA_ADMIN_PASSWORD
dash_import=("../rendered/General/manual-pod-scenarios.json")

#dash_import=("../rendered/k8s/k8s-perf.json")
dash_import

