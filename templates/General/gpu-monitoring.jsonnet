local panels = import '../../assets/gpu-monitoring/panels.libsonnet';
local queries = import '../../assets/gpu-monitoring/queries.libsonnet';
local variables = import '../../assets/gpu-monitoring/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('GPU Monitoring')
+ g.dashboard.withDescription('NVIDIA GPU monitoring and usage metrics from Mokka simulation')
+ g.dashboard.withTags(['krkn', 'gpu', 'monitoring', 'mokka', 'nvidia'])
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
  variables.pod,
  variables.gpu_index,
])

+ g.dashboard.withPanels([
  // GPU Overview Row
  g.panel.row.new('GPU Overview')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withPanels([]),

  // GPU Status Cards
  panels.stat.gpuCountStatPanel(
    'Total GPUs Allocated',
    queries.gpuCountAllocated.query(),
    { x: 0, y: 1, w: 4, h: 3 }
  ),

  panels.stat.gpuUtilizationStat(
    'Average GPU Utilization',
    queries.gpuUtilizationAverage.query(),
    { x: 4, y: 1, w: 4, h: 3 }
  ),

  panels.stat.gpuTemperatureStat(
    'Max GPU Temperature',
    queries.gpuTemperatureMax.query(),
    { x: 8, y: 1, w: 4, h: 3 }
  ),

  panels.stat.gpuCountStatPanel(
    'Idle GPUs',
    queries.gpuIdleTime.query(),
    { x: 12, y: 1, w: 4, h: 3 }
  ),

  // GPU Memory Row
  g.panel.row.new('GPU Memory')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 4, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.gpuMemoryTimeSeries(
      'GPU Memory Usage Over Time',
      queries.gpuMemoryUsed.query(),
      { x: 0, y: 5, w: 12, h: 8 }
    ),

    panels.timeSeries.gpuMemoryTimeSeries(
      'GPU Memory Utilization %',
      queries.gpuMemoryUtilizationPercent.query(),
      { x: 12, y: 5, w: 12, h: 8 }
    ),

    panels.timeSeries.gpuMemoryTimeSeries(
      'GPU Memory Free',
      queries.gpuMemoryFree.query(),
      { x: 0, y: 13, w: 12, h: 8 }
    ),

    panels.timeSeries.gpuMemoryTimeSeries(
      'GPU Memory Change Rate (MB/s)',
      queries.gpuMemoryTrend.query(),
      { x: 12, y: 13, w: 12, h: 8 }
    ),
  ]),

  // GPU Utilization Row
  g.panel.row.new('GPU Utilization & Performance')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 5, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.gpuUtilizationTimeSeries(
      'GPU Compute Utilization %',
      queries.gpuUtilization.query(),
      { x: 0, y: 6, w: 12, h: 8 }
    ),

    panels.gauge.gpuMemoryGauge(
      'Current Memory Usage by GPU',
      queries.gpuMemoryUtilizationPercent.query(),
      { x: 12, y: 6, w: 12, h: 8 }
    ),

    panels.timeSeries.gpuTemperatureTimeSeries(
      'GPU Temperature',
      queries.gpuTemperature.query(),
      { x: 0, y: 14, w: 12, h: 8 }
    ),

    panels.timeSeries.gpuMemoryTimeSeries(
      'GPU Power Draw',
      queries.gpuPowerUsage.query(),
      { x: 12, y: 14, w: 12, h: 8 }
    ),
  ]),

  // Pod Allocation Row
  g.panel.row.new('Pod GPU Allocation')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 6, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.table.gpuAllocationTable(
      'Pod GPU Allocation',
      queries.gpuCountByPod.query(),
      { x: 0, y: 7, w: 24, h: 10 }
    ),

    panels.timeSeries.gpuMemoryTimeSeries(
      'Memory Usage by Pod',
      queries.gpuMemoryByPod.query(),
      { x: 0, y: 17, w: 24, h: 8 }
    ),
  ]),

  // Alerts & Warnings Row
  g.panel.row.new('Alerts & Warnings')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 7, w: 24, h: 1 })
  + g.panel.row.withPanels([
    g.panel.table.new('High Memory Usage Alerts')
    + g.panel.table.queryOptions.withTargets([
      g.query.prometheus.new('$datasource', queries.gpuMemoryPressure.query()),
    ])
    + g.panel.table.options.withShowHeader(true)
    + g.panel.withGridPos({ x: 0, y: 8, w: 12, h: 6 }),

    g.panel.table.new('GPU Errors')
    + g.panel.table.queryOptions.withTargets([
      g.query.prometheus.new('$datasource', queries.gpuErrors.query()),
    ])
    + g.panel.table.options.withShowHeader(true)
    + g.panel.withGridPos({ x: 12, y: 8, w: 12, h: 6 }),
  ]),
])
