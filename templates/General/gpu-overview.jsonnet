local panels = import '../../assets/gpu-overview/panels.libsonnet';
local queries = import '../../assets/gpu-overview/queries.libsonnet';
local variables = import '../../assets/gpu-overview/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('GPU Cluster Overview')
+ g.dashboard.withDescription('GPU inventory comes from Kubernetes node capacity metrics. Per-device utilization, memory, power, temperature, and clocks require NVIDIA DCGM Exporter metrics.')
+ g.dashboard.withTags(['gpu', 'nvidia', 'prometheus', 'cluster'])
+ g.dashboard.time.withFrom('now-1h')
+ g.dashboard.time.withTo('now')
+ g.dashboard.withTimezone('utc')
+ g.dashboard.timepicker.withRefreshIntervals(['5s', '10s', '30s', '1m', '5m', '15m', '1h'])
+ g.dashboard.withRefresh('30s')
+ g.dashboard.withEditable(true)
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.Datasource,
  variables.region,
  variables.zone,
  variables.gpu_node_pool,
  variables.instance_type,
  variables.gpu_node,
  variables.gpu,
])
+ g.dashboard.withPanels([
  g.panel.row.new('Cluster Summary')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 }),

  panels.stat('GPU Nodes', 'short', queries.gpuNodeCount.query(), { x: 0, y: 1, w: 6, h: 4 }),
  panels.stat('GPUs Advertised by Nodes', 'short', queries.gpuCount.query(), { x: 6, y: 1, w: 6, h: 4 }),
  panels.stat('DCGM GPUs Reporting', 'short', queries.dcgmGpuCount.query(), { x: 12, y: 1, w: 6, h: 4 }),
  panels.stat('Average GPU Utilisation', 'percent', queries.averageUtilization.query(), { x: 18, y: 1, w: 6, h: 4 }),

  g.panel.row.new('GPU Telemetry')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 5, w: 24, h: 1 }),

  panels.timeSeries('GPU Capacity by Node', 'short', queries.gpuCapacityByNode.query(), { x: 0, y: 6, w: 24, h: 8 }),
  panels.timeSeries('GPU Utilisation (DCGM)', 'percent', queries.utilization.query(), { x: 0, y: 14, w: 12, h: 8 }),
  panels.timeSeries('GPU Memory Used (MiB, DCGM)', 'mebibytes', queries.memoryUsed.query(), { x: 12, y: 14, w: 12, h: 8 }),
  panels.timeSeries('GPU Memory Utilisation (DCGM)', 'percent', queries.memoryUtilization.query(), { x: 0, y: 22, w: 12, h: 8 }),
  panels.timeSeries('GPU Power Draw (W, DCGM)', 'watt', queries.power.query(), { x: 12, y: 22, w: 12, h: 8 }),
  panels.timeSeries('GPU Temperature (°C, DCGM)', 'celsius', queries.temperature.query(), { x: 0, y: 30, w: 12, h: 8 }),
  panels.timeSeries('GPU SM Clock (MHz, DCGM)', 'megahertz', queries.smClock.query(), { x: 12, y: 30, w: 12, h: 8 }),
])
