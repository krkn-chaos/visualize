local panels = import '../../assets/pod-perf/panels.libsonnet';
local queries = import '../../assets/pod-perf/queries.libsonnet';
local variables = import '../../assets/pod-perf/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('Pod Performance')
+ g.dashboard.withDescription('Kubernetes Pod performance and status metrics')
+ g.dashboard.withTags(['krkn', 'pod', 'performance'])
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
])

+ g.dashboard.withPanels([
  g.panel.row.new('Pod Overview')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.stat.genericStatPanel('Pods by Phase', 'none', queries.podCountTotal.query(), { x: 0, y: 1, w: 24, h: 3 }),
    panels.table.genericTablePanel('Pod Information', queries.podInfo.query(), { x: 0, y: 4, w: 24, h: 8 }),
  ]),

  g.panel.row.new('Pod Status')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 1, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.genericTimeSeriesLegendPanel('Pod Count by Phase', 'none', queries.podPhaseCount.query(), { x: 0, y: 2, w: 12, h: 6 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Pod Count by Namespace', 'none', queries.podCountByNamespace.query(), { x: 12, y: 2, w: 12, h: 6 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Ready Pods by Namespace', 'none', queries.podReadyCount.query(), { x: 0, y: 8, w: 12, h: 6 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Container Restarts', 'short', queries.podRestarts.query(), { x: 12, y: 8, w: 12, h: 6 }),
  ]),

  g.panel.row.new('CPU Metrics')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 2, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.genericTimeSeriesLegendPanel('CPU Usage by Pod', 'percent', queries.podCpuUsage.query(), { x: 0, y: 3, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('CPU Usage by Container', 'percent', queries.podCpuByContainer.query(), { x: 12, y: 3, w: 12, h: 8 }),
  ]),

  g.panel.row.new('Memory Metrics')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 3, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.genericTimeSeriesLegendPanel('Memory Working Set', 'bytes', queries.podMemoryWorkingSet.query(), { x: 0, y: 4, w: 8, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Memory RSS', 'bytes', queries.podMemoryRss.query(), { x: 8, y: 4, w: 8, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Memory Usage', 'bytes', queries.podMemoryUsage.query(), { x: 16, y: 4, w: 8, h: 8 }),
  ]),

  g.panel.row.new('Network Metrics')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 4, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.genericTimeSeriesLegendPanel('Network Receive Throughput', 'Bps', queries.podNetworkReceiveBytes.query(), { x: 0, y: 5, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Network Transmit Throughput', 'Bps', queries.podNetworkTransmitBytes.query(), { x: 12, y: 5, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Network Receive Packets', 'pps', queries.podNetworkReceivePackets.query(), { x: 0, y: 13, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Network Transmit Packets', 'pps', queries.podNetworkTransmitPackets.query(), { x: 12, y: 13, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Network Receive Errors', 'short', queries.podNetworkReceiveErrors.query(), { x: 0, y: 21, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Network Transmit Errors', 'short', queries.podNetworkTransmitErrors.query(), { x: 12, y: 21, w: 12, h: 8 }),
  ]),

  g.panel.row.new('Storage Metrics')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 5, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.genericTimeSeriesLegendPanel('Storage Read Throughput', 'Bps', queries.podStorageReadBytes.query(), { x: 0, y: 6, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Storage Write Throughput', 'Bps', queries.podStorageWriteBytes.query(), { x: 12, y: 6, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Storage Read IOPS', 'iops', queries.podStorageReadOps.query(), { x: 0, y: 14, w: 12, h: 8 }),
    panels.timeSeries.genericTimeSeriesLegendPanel('Storage Write IOPS', 'iops', queries.podStorageWriteOps.query(), { x: 12, y: 14, w: 12, h: 8 }),
  ]),
])
