local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local generateTimeSeriesQuery(query, legend) = [
  local prometheusQuery = g.query.prometheus;
  prometheusQuery.new('$' + variables.Datasource.name, query)
  + prometheusQuery.withFormat('time_series')
  + prometheusQuery.withIntervalFactor(2)
  + prometheusQuery.withLegendFormat(legend),
];

{
  NamespaceRecieveBandwidth: {
    query():
      generateTimeSeriesQuery('sum(irate(container_network_receive_bytes_total{cluster="",namespace=~"$namespace"}[5m])) by (pod)', '{{pod}}'),
  },
  NamespaceTransmitBandwidth: {
    query():
      generateTimeSeriesQuery('sum(irate(container_network_transmit_bytes_total{cluster="",namespace=~"$namespace"}[5m])) by (pod)', '{{pod}}'),


  },
  NamespaceReceivePackets: {
    query():
      generateTimeSeriesQuery('sum(irate(container_network_receive_packets_total{cluster="",namespace=~"$namespace"}[5m])) by (pod)', '{{pod}}'),
  },

  NamespaceTransmitPackets: {
    query():
      generateTimeSeriesQuery('sum(irate(container_network_transmit_packets_total{cluster="",namespace=~"$namespace"}[5m])) by (pod)', '{{pod}}'),
  },
}
