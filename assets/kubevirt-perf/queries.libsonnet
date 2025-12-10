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
      generateTableQuery('kubevirt_vmi_info{namespace=~"$namespace", phase="running"}'),
  },

  vmiPhaseCount: {
    query():
      generateTimeSeriesQuery(
        'count by (phase) (kubevirt_vmi_phase_count{namespace=~"$namespace"})',
        '{{phase}}'
      ),
  },

  vmiCountByNamespace: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (kubevirt_vmi_info{namespace=~"$namespace"})',
        '{{namespace}}'
      ),
  },

  vmiCountTotal: {
    query():
      generateTimeSeriesQuery(
        'count by (phase) (kubevirt_vmi_info{namespace=~"$namespace"})',
        '{{phase}}'
      ),
  },

  vmiPhaseOverTime: {
    query():
      generateTimeSeriesQuery(
        '(kubevirt_vmi_info{namespace=~"$namespace", phase="pending"} * 0 + 0.01) or (kubevirt_vmi_info{namespace=~"$namespace", phase="scheduling"} * 0 + 0.25) or (kubevirt_vmi_info{namespace=~"$namespace", phase="scheduled"} * 0 + 0.5) or (kubevirt_vmi_info{namespace=~"$namespace", phase="running"} * 0 + 1) or (kubevirt_vmi_info{namespace=~"$namespace", phase="succeeded"} * 0 + 1.5) or (kubevirt_vmi_info{namespace=~"$namespace", phase="failed"} * 0 - 1)',
        '{{name}}'
      ),
  },

  // CPU Metrics
  vmiCpuUsage: {
    query():
      generateTimeSeriesQuery(
        '(sum(rate(kubevirt_vmi_vcpu_seconds{namespace=~"$namespace"}[$interval])) by (name, namespace) * 100) or (sum(rate(kubevirt_vmi_cpu_system_seconds{namespace=~"$namespace"}[$interval]) + rate(kubevirt_vmi_cpu_user_seconds{namespace=~"$namespace"}[$interval])) by (name, namespace) * 100)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiCpuSystem: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_cpu_system_seconds{namespace=~"$namespace"}[$interval])) by (name, namespace) * 100',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiCpuUser: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_cpu_user_seconds{namespace=~"$namespace"}[$interval])) by (name, namespace) * 100',
        '{{namespace}}/{{name}}'
      ),
  },

  // Memory Metrics
  vmiMemoryAvailable: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_available_bytes{namespace=~"$namespace"}',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiMemoryUsed: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_used_bytes{namespace=~"$namespace"}',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiMemoryResident: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_resident_bytes{namespace=~"$namespace"}',
        '{{namespace}}/{{name}}'
      ),
  },

  // Network Metrics
  vmiNetworkReceiveBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_bytes_total{namespace=~"$namespace"}[$interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_bytes_total{namespace=~"$namespace"}[$interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkReceivePackets: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_packets_total{namespace=~"$namespace"}[$interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitPackets: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_packets_total{namespace=~"$namespace"}[$interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkReceiveErrors: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_errors_total{namespace=~"$namespace"}[$interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  vmiNetworkTransmitErrors: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_errors_total{namespace=~"$namespace"}[$interval])) by (name, namespace, interface)',
        '{{namespace}}/{{name}} - {{interface}}'
      ),
  },

  // Storage Metrics
  vmiStorageReadBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_read_traffic_bytes_total{namespace=~"$namespace"}[$interval])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },

  vmiStorageWriteBytes: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_write_traffic_bytes_total{namespace=~"$namespace"}[$interval])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },

  vmiStorageReadOps: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_iops_read_total{namespace=~"$namespace"}[$interval])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },

  vmiStorageWriteOps: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_iops_write_total{namespace=~"$namespace"}[$interval])) by (name, namespace, drive)',
        '{{namespace}}/{{name}} - {{drive}}'
      ),
  },
}
