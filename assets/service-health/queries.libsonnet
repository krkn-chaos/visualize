local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local ns = 'namespace=~"$namespace"';

local ts(query, legend) = [
  local p = g.query.prometheus;
  p.new('$' + variables.Datasource.name, query)
  + p.withFormat('time_series')
  + p.withIntervalFactor(2)
  + p.withLegendFormat(legend),
];

local instant(query, legend) = [
  local p = g.query.prometheus;
  p.new('$' + variables.Datasource.name, query)
  + p.withFormat('time_series')
  + p.withInstant(true)
  + p.withLegendFormat(legend),
];

local table(query, legend) = [
  local p = g.query.prometheus;
  p.new('$' + variables.Datasource.name, query)
  + p.withFormat('table')
  + p.withInstant(true)
  + p.withLegendFormat(legend),
];

{
  // ── Summary stats ─────────────────────────────────────────────────────────────

  servicesTotal: {
    query(): instant(
      'count(kube_service_info{' + ns + '}) or vector(0)',
      'Services'
    ),
  },

  podsReady: {
    query(): instant(
      'count(kube_pod_status_ready{' + ns + ', condition="true"} == 1) or vector(0)',
      'Ready'
    ),
  },

  podsNotReady: {
    query(): instant(
      'count(kube_pod_status_phase{' + ns + ', phase=~"Pending|Failed"} == 1) or vector(0)',
      'Not Ready'
    ),
  },

  deploymentsHealthy: {
    query(): instant(
      'count(kube_deployment_status_replicas_unavailable{' + ns + '} == 0) or vector(0)',
      'Healthy'
    ),
  },

  deploymentsDegraded: {
    query(): instant(
      'count(kube_deployment_status_replicas_unavailable{' + ns + '} > 0) or vector(0)',
      'Degraded'
    ),
  },

  // ── Service endpoint table ────────────────────────────────────────────────────

  // One row per service: available addresses, not-ready addresses
  endpointAvailable: {
    query(): table(
      'kube_endpoint_address_available{' + ns + '}',
      'available'
    ),
  },

  endpointNotReady: {
    query(): table(
      'kube_endpoint_address_not_ready{' + ns + '}',
      'not_ready'
    ),
  },

  // ── Pod table ─────────────────────────────────────────────────────────────────

  podPhaseTable: {
    query(): table(
      'kube_pod_status_phase{' + ns + '} == 1',
      '{{phase}}'
    ),
  },

  podReadyTable: {
    query(): table(
      'kube_pod_status_ready{' + ns + ', condition="true"}',
      'ready'
    ),
  },

  // ── Deployment table ──────────────────────────────────────────────────────────

  deploymentDesired: {
    query(): table(
      'kube_deployment_status_replicas{' + ns + '}',
      'desired'
    ),
  },

  deploymentAvailable: {
    query(): table(
      'kube_deployment_status_replicas_available{' + ns + '}',
      'available'
    ),
  },

  deploymentUnavailable: {
    query(): table(
      'kube_deployment_status_replicas_unavailable{' + ns + '}',
      'unavailable'
    ),
  },

  // ── Service table ────────────────────────────────────────────────────────────
  // Join kube_service_info (cluster_ip) with kube_service_spec_type (type) on (namespace, service)

  serviceTable: {
    query(): table(
      'kube_service_info{' + ns + '}'
      + ' * on(namespace, service) group_left(type)'
      + ' kube_service_spec_type{' + ns + '}',
      '{{namespace}} / {{service}}'
    ),
  },

  // ── Routes ───────────────────────────────────────────────────────────────────
  // openshift_route_status has type=Admitted|Rejected|Accepted per router ingress.

  routesTotal: {
    query(): instant(
      'count(openshift_route_info{' + ns + '}) or vector(0)',
      'Routes'
    ),
  },

  // Table: one row per route showing admission status from openshift-state-metrics
  routeStatusTable: {
    query(): table(
      'openshift_route_status{' + ns + '}',
      '{{namespace}} / {{route}}'
    ),
  },

  // ── Time series ───────────────────────────────────────────────────────────────

  servicesUpOverTime: {
    query(): ts(
      'count(kube_endpoint_address_available{' + ns + '} > 0) or vector(0)',
      'Up'
    ) + ts(
      'count(kube_endpoint_address_available{' + ns + '} == 0) or vector(0)',
      'Down'
    ),
  },

  podPhasesOverTime: {
    query(): ts(
      'sum by (phase) (kube_pod_status_phase{' + ns + '} == 1)',
      '{{phase}}'
    ),
  },

  deploymentUnavailableOverTime: {
    query(): ts(
      'sum by (namespace, deployment) (kube_deployment_status_replicas_unavailable{' + ns + '} > 0)',
      '{{namespace}}/{{deployment}}'
    ),
  },
}
