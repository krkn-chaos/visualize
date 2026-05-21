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
      generateTableQuery('max by (namespace, pod, container, image) (container_start_time_seconds{namespace=~"$namespace", container!=""})'),
  },

  podCountTotal: {
    query():
      generateTimeSeriesQuery(
        'count(group by (namespace, pod) (container_cpu_usage_seconds_total{namespace=~"$namespace", container!=""}))',
        'Active Pods'
      ),
  },

  // Status
  podStatusOverTime: {
    query():
      generateTimeSeriesQuery(
        |||
          (kube_pod_status_phase{namespace=~"$namespace", phase="Pending"} == 1) * 0 + 3
          or (
            (kube_pod_status_phase{namespace=~"$namespace", phase="Running"} == 1)
            unless on(namespace, pod) (kube_pod_container_status_waiting_reason{namespace=~"$namespace", reason="CrashLoopBackOff"} == 1)
          ) * 0 + 4
          or max by (namespace, pod) ((kube_pod_container_status_waiting_reason{namespace=~"$namespace", reason="CrashLoopBackOff"} == 1) * 0 + 2)
          or (kube_pod_status_phase{namespace=~"$namespace", phase="Succeeded"} == 1) * 0 + 1
          or (kube_pod_status_phase{namespace=~"$namespace", phase="Failed"} == 1) * 0 + 2
          or (kube_pod_status_phase{namespace=~"$namespace", phase="Unknown"} == 1) * 0 + 0
        |||,
        '{{namespace}}/{{pod}}'
      ),
  },

  podCountByNamespace: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (group by (namespace, pod) (container_cpu_usage_seconds_total{namespace=~"$namespace", container!=""}))',
        '{{namespace}}'
      ),
  },

  podActiveContainers: {
    query():
      generateTimeSeriesQuery(
        'count by (namespace) (container_cpu_usage_seconds_total{namespace=~"$namespace", container!=""})',
        '{{namespace}}'
      ),
  },

  podRestarts: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (changes(container_start_time_seconds{namespace=~"$namespace", container!=""}[5m]))',
        '{{namespace}}/{{pod}}'
      ),
  },

  podOomEvents: {
    query():
      generateTimeSeriesQuery(
        'sum by (pod, namespace) (increase(container_oom_events_total{namespace=~"$namespace", container!=""}[$__rate_interval]))',
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

  // Storage Metrics (PVC-level)
  podPvcUsed: {
    query():
      generateTimeSeriesQuery(
        'kubelet_volume_stats_used_bytes{namespace=~"$namespace"}',
        '{{namespace}}/{{persistentvolumeclaim}}'
      ),
  },

  podPvcCapacity: {
    query():
      generateTimeSeriesQuery(
        'kubelet_volume_stats_capacity_bytes{namespace=~"$namespace"}',
        '{{namespace}}/{{persistentvolumeclaim}}'
      ),
  },

  podPvcAvailable: {
    query():
      generateTimeSeriesQuery(
        'kubelet_volume_stats_available_bytes{namespace=~"$namespace"}',
        '{{namespace}}/{{persistentvolumeclaim}}'
      ),
  },

  podPvcInodes: {
    query():
      generateTimeSeriesQuery(
        'kubelet_volume_stats_inodes_used{namespace=~"$namespace"}',
        '{{namespace}}/{{persistentvolumeclaim}}'
      ),
  },
}
