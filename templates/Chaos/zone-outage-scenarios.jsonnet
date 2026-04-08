local panels = import '../../assets/zone-outage-scenarios/panels.libsonnet';
local queries = import '../../assets/zone-outage-scenarios/queries.libsonnet';
local variables = import '../../assets/zone-outage-scenarios/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  description: 'Zone Outage Scenarios - Chaos Engineering (zone_outages_scenarios)',
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
    'zone-outage',
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
  title: 'Zone Outage Scenarios - Chaos Engineering (zone_outages_scenarios)',
  uid: null,
  version: 1,
  weekStart: '',
}
