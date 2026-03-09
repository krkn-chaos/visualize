local panels = import '../../assets/cluster-shut-down-scenarios/panels.libsonnet';
local queries = import '../../assets/cluster-shut-down-scenarios/queries.libsonnet';
local variables = import '../../assets/cluster-shut-down-scenarios/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  description: 'Cluster Shut Down Scenarios - Chaos Engineering (cluster_shut_down_scenarios)',
  editable: false,
  fiscalYearStartMonth: 0,
  graphTooltip: 1,
  id: null,
  links: [],
  liveNow: false,
  panels: panels.getAllPanels(),
  refresh: '30s',
  revision: 1,
  schemaVersion: 38,
  style: 'dark',
  tags: [
    'chaos-engineering',
    'cluster-disruption',
    'kubernetes',
    'reliability',
  ],
  templating: {
    list: variables.getAllVariables(),
  },
  time: {
    from: 'now-30d',
    to: 'now',
  },
  timepicker: {
    refresh_intervals: [
      '5s',
      '10s',
      '30s',
      '1m',
      '5m',
      '15m',
      '30m',
      '1h',
      '2h',
      '1d',
    ],
    time_options: [
      '5m',
      '15m',
      '1h',
      '6h',
      '12h',
      '24h',
      '2d',
      '7d',
      '30d',
    ],
  },
  timezone: 'utc',
  title: 'Cluster Shut Down Scenarios - Chaos Engineering (cluster_shut_down_scenarios)',
  uid: null,
  version: 1,
  weekStart: '',
}
