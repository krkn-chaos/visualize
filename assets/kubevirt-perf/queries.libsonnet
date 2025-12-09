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
      generateTableQuery('kubevirt_vmi_info{namespace=~"$namespace", name=~"$vmi"}'),
  },

  vmiCpuUsage: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_cpu_system_seconds_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name) + sum(rate(kubevirt_vmi_cpu_user_seconds_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiMemoryUsage: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_resident_bytes{namespace=~"$namespace", name=~"$vmi"}',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiMemoryAvailable: {
    query():
      generateTimeSeriesQuery(
        'kubevirt_vmi_memory_available_bytes{namespace=~"$namespace", name=~"$vmi"}',
        '{{namespace}}/{{name}} Available'
      ),
  },

  vmiNetworkReceive: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_bytes_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiNetworkTransmit: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_bytes_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiNetworkReceivePackets: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_packets_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiNetworkTransmitPackets: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_packets_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiNetworkReceiveErrors: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_receive_errors_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiNetworkTransmitErrors: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_network_transmit_errors_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiStorageRead: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_read_traffic_bytes_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiStorageWrite: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_write_traffic_bytes_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiStorageReadIops: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_iops_read_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
  },

  vmiStorageWriteIops: {
    query():
      generateTimeSeriesQuery(
        'sum(rate(kubevirt_vmi_storage_iops_write_total{namespace=~"$namespace", name=~"$vmi"}[$interval])) by (namespace, name)',
        '{{namespace}}/{{name}}'
      ),
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
        'count(kubevirt_vmi_info{namespace=~"$namespace"})',
        'Total VMIs'
      ),
  },
}
