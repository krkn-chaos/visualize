local panels = import '../../assets/kubevirt-perf/panels.libsonnet';
local queries = import '../../assets/kubevirt-perf/queries.libsonnet';
local variables = import '../../assets/kubevirt-perf/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('KubeVirt Performance')
+ g.dashboard.withDescription('KubeVirt Virtual Machine Instance performance metrics')
+ g.dashboard.withTags(['krkn', 'kubevirt', 'performance'])
+ g.dashboard.time.withFrom('now-1h')
+ g.dashboard.time.withTo('now')
+ g.dashboard.withTimezone('utc')
+ g.dashboard.timepicker.withRefreshIntervals(['5s', '10s', '30s', '1m', '5m', '15m', '30m', '1h', '2h', '1d'])
+ g.dashboard.timepicker.withTimeOptions(['5m', '15m', '1h', '6h', '12h', '24h', '2d', '7d', '30d'])
+ g.dashboard.withRefresh('30s')
+ g.dashboard.withEditable(true)
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.Datasource,
  variables.namespace,
  variables.vmi,
  variables.interval,
])

+ g.dashboard.withPanels([
  g.panel.row.new('VMI Overview')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.stat.genericStatPanel('Total VMIs', 'none', queries.vmiCountTotal.query(), { x: 0, y: 1, w: 8, h: 3 }),
    panels.table.genericTablePanel('Virtual Machine Instances', queries.vmiInfo.query(), { x: 0, y: 4, w: 24, h: 8 }),
  ]),

  g.panel.row.new('VMI Phase Status')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 1, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.genericTimeSeriesLegendPanel('VMI Count by Phase', 'none', queries.vmiPhaseCount.query(), { x: 0, y: 2, w: 12, h: 6 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('VMI Count by Namespace', 'none', queries.vmiCountByNamespace.query(), { x: 12, y: 2, w: 12, h: 6 }),
  ]),

])
