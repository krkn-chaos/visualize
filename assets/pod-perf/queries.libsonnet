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
  // Overview
  podInfo: {
    query():
      generateTableQuery('kube_pod_info{namespace=~"$namespace"}'),
  },

  podCountTotal: {
    query():
      generateTimeSeriesQuery(
        'count by (phase) (kube_pod_status_phase{namespace=~"$namespace"} == 1)',
        '{{phase}}'
      ),
  },

  // Status
  podPhaseCount: {
    query():
      generateTimeSeriesQuery(
        'count by (phase) (kube_pod_status_phase{namespace=~"$namespace"} == 1)',
        '{{phase}}'
      ),
  },

  podCountByNamespace: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (kube_pod_info{namespace=~"$namespace"})',
        '{{namespace}}'
      ),
  },

  podReadyCount: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (kube_pod_status_ready{namespace=~"$namespace", condition="true"} == 1)',
        '{{namespace}}'
      ),
  },

  podRestarts: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (increase(kube_pod_container_status_restarts_total{namespace=~"$namespace"}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  // CPU Metrics
  podCpuUsage: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_cpu_usage_seconds_total{namespace=~"$namespace", container!=""}[$__rate_interval])) * 100',
        '{{namespace}}/{{pod}}'
      ),
  },

  podCpuByContainer: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, container, namespace) (rate(container_cpu_usage_seconds_total{namespace=~"$namespace", container!=""}[$__rate_interval])) * 100',
        '{{namespace}}/{{pod}}/{{container}}'
      ),
  },

  // Memory Metrics
  podMemoryWorkingSet: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (container_memory_working_set_bytes{namespace=~"$namespace", container!=""})',
        '{{namespace}}/{{pod}}'
      ),
  },

  podMemoryRss: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (container_memory_rss{namespace=~"$namespace", container!=""})',
        '{{namespace}}/{{pod}}'
      ),
  },

  podMemoryUsage: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (container_memory_usage_bytes{namespace=~"$namespace", container!=""})',
        '{{namespace}}/{{pod}}'
      ),
  },

  // Network Metrics
  podNetworkReceiveBytes: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_network_receive_bytes_total{namespace=~"$namespace"}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podNetworkTransmitBytes: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_network_transmit_bytes_total{namespace=~"$namespace"}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podNetworkReceivePackets: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_network_receive_packets_total{namespace=~"$namespace"}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podNetworkTransmitPackets: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_network_transmit_packets_total{namespace=~"$namespace"}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podNetworkReceiveErrors: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_network_receive_errors_total{namespace=~"$namespace"}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podNetworkTransmitErrors: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_network_transmit_errors_total{namespace=~"$namespace"}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  // Storage Metrics
  podStorageReadBytes: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_fs_reads_bytes_total{namespace=~"$namespace", container!=""}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podStorageWriteBytes: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_fs_writes_bytes_total{namespace=~"$namespace", container!=""}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podStorageReadOps: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_fs_reads_total{namespace=~"$namespace", container!=""}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podStorageWriteOps: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (rate(container_fs_writes_total{namespace=~"$namespace", container!=""}[$__rate_interval]))',
        '{{namespace}}/{{pod}}'
      ),
  },
}
