local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local generateTimeSeriesQuery(query, legend) = [
  local prometheusQuery = g.query.prometheus;
  prometheusQuery.new('$' + variables.Datasource.name, query)
  + prometheusQuery.withFormat('time_series')
  + prometheusQuery.withIntervalFactor(2)
  + prometheusQuery.withLegendFormat(legend),
];

local generateTableQuery(query) = [
  local prometheusQuery = g.query.prometheus;
  prometheusQuery.new('$' + variables.Datasource.name, query)
  + prometheusQuery.withFormat('table')
  + prometheusQuery.withInstant(true),
];

{
  vmiInfo: {
    query():
      generateTableQuery('kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="running"}'),
  },

  vmiPhaseCount: {
    query():
      generateTimeSeriesQuery(
        'count by (phase) (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi"})',
        '{{phase}}'
      ),
  },

  vmiCountByNamespace: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi"})',
        '{{namespace}}'
      ),
  },

  vmiCountTotal: {
    query():
      generateTimeSeriesQuery(
        'count by (phase) (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi"})',
        '{{phase}}'
      ),
  },

  vmiReadyCount: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="running"})',
        '{{namespace}}'
      ),
  },

  vmiEvictableCount: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", evictable="true"})',
        '{{namespace}}'
      ),
  },

  vmiOutdatedCount: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", outdated="true"})',
        '{{namespace}}'
      ),
  },

  vmiPhaseOverTime: {
    query():
      generateTimeSeriesQuery(
        '(kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="pending"} * 0 + 1)'
        + ' or (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="scheduling"} * 0 + 2)'
        + ' or (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="scheduled"} * 0 + 3)'
        + ' or (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="running"} * 0 + 4)'
        + ' or (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="succeeded"} * 0 + 5)'
        + ' or (kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi", phase="failed"} * 0 + 0)',
        '{{namespace}}/{{name}}'
      ),
  },

  // Phase transitions counter — captures brief phases (scheduling/scheduled) that
  // kubevirt_vmi_info misses due to 30s scrape interval. Reports under openshift-cnv
  // regardless of VMI namespace (KubeVirt control-plane reporting behavior).
  vmiPhaseTransitions: {
    query():
      generateTimeSeriesQuery(
        'increase(kubevirt_vmi_phase_transition_time_seconds_count{name=~"$vmi"}[$__rate_interval])',
        '{{phase}}'
      ),
  },

  // CPU Metrics
  vmiCpuUsage: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_cpu_usage_seconds_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace) * 100',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiCpuVcpuRunning: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_vcpu_seconds_total{namespace=~"$namespace", name=~"$vmi", state="running"}[1m])) by (name, namespace) * 100',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiCpuPerVcpu: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_vcpu_seconds_total{namespace=~"$namespace", name=~"$vmi", state="running"}[1m])) by (name, namespace, id) * 100',
        '{{namespace}}/{{name}} vCPU{{id}}'
      ),
  },

  // Memory Metrics
  vmiMemoryAvailable: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_available_bytes{namespace=~"$namespace", name=~"$vmi"}',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiMemoryUsed: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_used_bytes{namespace=~"$namespace", name=~"$vmi"}',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiMemoryResident: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_resident_bytes{namespace=~"$namespace", name=~"$vmi"}',
        '{{namespace}}/{{name}}'
      ),
  },

  // Network Metrics
  vmiNetworkReceiveBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_bytes_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_bytes_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkReceivePackets: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_packets_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitPackets: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_packets_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkReceiveErrors: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_errors_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitErrors: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_errors_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  // Live Network Metrics (rate with $__rate_interval, lastNotNull legend for current value)
  vmiNetworkReceiveBytesLive: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_bytes_total{namespace=~"$namespace"}[$__rate_interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitBytesLive: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_bytes_total{namespace=~"$namespace"}[$__rate_interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkReceivePacketsLive: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_packets_total{namespace=~"$namespace"}[$__rate_interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitPacketsLive: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_packets_total{namespace=~"$namespace"}[$__rate_interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkReceiveErrorsLive: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_errors_total{namespace=~"$namespace"}[$__rate_interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitErrorsLive: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_errors_total{namespace=~"$namespace"}[$__rate_interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  // Storage Metrics
  vmiStorageReadBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_read_traffic_bytes_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },

  vmiStorageWriteBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_write_traffic_bytes_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },

  vmiStorageReadOps: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_iops_read_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },

  vmiStorageWriteOps: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_iops_write_total{namespace=~"$namespace", name=~"$vmi"}[1m])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },

  // Network Chaos Validation — Layer 1: VMI-level (KubeVirt exporter)
  vmiChaosReceiveBytes: {
    query():
      generateTimeSeriesQuery(
        'rate(kubevirt_vmi_network_receive_bytes_total{name=~"$vmi", namespace=~"$namespace"}[30s])',
        'rx - {{name}}/{{interface}}'
      ),
  },

  vmiChaosTransmitBytes: {
    query():
      generateTimeSeriesQuery(
        'rate(kubevirt_vmi_network_transmit_bytes_total{name=~"$vmi", namespace=~"$namespace"}[30s])',
        'tx - {{name}}/{{interface}}'
      ),
  },

  vmiChaosReceiveDropped: {
    query():
      generateTimeSeriesQuery(
        'rate(kubevirt_vmi_network_receive_packets_dropped_total{name=~"$vmi", namespace=~"$namespace"}[30s])',
        'dropped rx - {{name}}/{{interface}}'
      ),
  },

  vmiChaosTransmitDropped: {
    query():
      generateTimeSeriesQuery(
        'rate(kubevirt_vmi_network_transmit_packets_dropped_total{name=~"$vmi", namespace=~"$namespace"}[30s])',
        'dropped tx - {{name}}/{{interface}}'
      ),
  },

  vmiChaosAllNamespaceReceive: {
    query():
      generateTimeSeriesQuery(
        'rate(kubevirt_vmi_network_receive_bytes_total{namespace=~"$namespace"}[30s])',
        '{{name}}/{{interface}}'
      ),
  },

  // Network Chaos Validation — Layer 2: probe pods (cAdvisor)
  vmiChaosProbeReceive: {
    query():
      generateTimeSeriesQuery(
        'rate(container_network_receive_bytes_total{pod=~"traffic-gen-($vmi)", namespace=~"$namespace"}[30s])',
        '{{pod}}'
      ),
  },

  vmiChaosAllProbesReceive: {
    query():
      generateTimeSeriesQuery(
        'rate(container_network_receive_bytes_total{pod=~"traffic-gen-.*", namespace=~"$namespace"}[30s])',
        '{{pod}}'
      ),
  },

  // Network Chaos Validation — Layer 3: before/during/after overlay (1m window)
  vmiChaosOverlayReceive: {
    query():
      generateTimeSeriesQuery(
        'rate(kubevirt_vmi_network_receive_bytes_total{name=~"$vmi", namespace=~"$namespace"}[1m])',
        'receive - {{name}}/{{interface}}'
      ),
  },

  vmiChaosOverlayTransmit: {
    query():
      generateTimeSeriesQuery(
        'rate(kubevirt_vmi_network_transmit_bytes_total{name=~"$vmi", namespace=~"$namespace"}[1m])',
        'transmit - {{name}}/{{interface}}'
      ),
  },
}
