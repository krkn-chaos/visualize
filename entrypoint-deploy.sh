#!/usr/bin/env bash
# Translates environment variables into CLI arguments for deploy.sh

set -euo pipefail

ARGS=()

# -c: k8s command (kubectl or oc)
ARGS+=(-c "${K8S_CMD:-kubectl}")

# -p: grafana admin password (only pass if explicitly set)
if [[ -n "${GRAFANA_PASSWORD:-}" ]]; then
  ARGS+=(-p "${GRAFANA_PASSWORD}")
fi

# -n: namespace
if [[ -n "${NAMESPACE:-}" ]]; then
  ARGS+=(-n "${NAMESPACE}")
fi

# -d: delete existing deployment
if [[ "${DELETE:-false}" == "true" ]]; then
  ARGS+=(-d)
fi

# -t and -b are read directly from PROMETHEUS_URL / PROMETHEUS_BEARER env vars
# by deploy.sh, so no CLI arg needed — just export them.

cd krkn-visualize
exec ./deploy.sh "${ARGS[@]}"
