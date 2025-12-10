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
      generateTableQuery('kubevirt_vmi_info{namespace=~"$namespace", name=~"virt-density"}'),
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
