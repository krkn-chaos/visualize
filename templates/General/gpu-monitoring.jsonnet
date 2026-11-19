local panels = import '../../assets/gpu-monitoring/panels.libsonnet';
local queries = import '../../assets/gpu-monitoring/queries.libsonnet';
local variables = import '../../assets/gpu-monitoring/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('GPU Monitoring')
+ g.dashboard.withUid('gpu-monitoring')
+ g.dashboard.withDescription('NVIDIA GPU monitoring and usage metrics from Mokka simulation (dcgm-exporter DCGM_FI_* metrics)')
+ g.dashboard.withTags(['krkn', 'gpu', 'monitoring', 'mokka', 'nvidia', 'dcgm'])
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
  variables.node,
  variables.namespace,
  variables.pod,
])

+ g.dashboard.withPanels([
  g.panel.row.new('GPU Overview')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.stat.gpuStatPanel('Total GPUs Detected', queries.gpuCountDetected, { x: 0, y: 1, w: 5, h: 3 }),
    panels.stat.gpuStatPanel('GPUs Allocated to Pods', queries.gpuCountAllocated, { x: 5, y: 1, w: 5, h: 3 }),
    panels.stat.gpuStatPanel('Idle GPUs (<10% util)', queries.gpuIdleTime, { x: 10, y: 1, w: 5, h: 3 }),
    panels.stat.gpuStatPanel('Average GPU Utilization', queries.gpuUtilizationAverage, { x: 15, y: 1, w: 5, h: 3 }, unit='percent'),
    panels.stat.gpuStatPanel('Max GPU Temperature', queries.gpuTemperatureMax, { x: 20, y: 1, w: 4, h: 3 }, unit='celsius'),
  ]),

  g.panel.row.new('GPU Memory')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 1, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.gpuTimeSeries('GPU Memory Usage Over Time', queries.gpuMemoryUsed, { x: 0, y: 2, w: 12, h: 8 }, unit='mbytes'),
    panels.timeSeries.gpuTimeSeries('GPU Memory Utilization %', queries.gpuMemoryUtilizationPercent, { x: 12, y: 2, w: 12, h: 8 }, unit='percent'),
    panels.timeSeries.gpuTimeSeries('GPU Memory Free', queries.gpuMemoryFree, { x: 0, y: 10, w: 12, h: 8 }, unit='mbytes'),
    panels.timeSeries.gpuTimeSeries('GPU Memory Change Rate (MiB/s)', queries.gpuMemoryTrend, { x: 12, y: 10, w: 12, h: 8 }),
  ]),

  g.panel.row.new('GPU Utilization & Performance')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 2, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.gpuTimeSeries('GPU Compute Utilization %', queries.gpuUtilization, { x: 0, y: 3, w: 12, h: 8 }, unit='percent'),
    panels.timeSeries.gpuTimeSeries('GPU Temperature', queries.gpuTemperature, { x: 12, y: 3, w: 12, h: 8 }, unit='celsius'),
    panels.timeSeries.gpuTimeSeries('GPU Power Draw', queries.gpuPowerUsage, { x: 0, y: 11, w: 12, h: 8 }, unit='watt'),
    panels.timeSeries.gpuTimeSeries('GPU Clocks', [queries.gpuSmClock, queries.gpuMemClock], { x: 12, y: 11, w: 12, h: 8 }, unit='MHz'),
    panels.timeSeries.gpuTimeSeries('PCIe Throughput', [queries.gpuPcieRx, queries.gpuPcieTx], { x: 0, y: 19, w: 12, h: 8 }, unit='Bps'),
    panels.timeSeries.gpuTimeSeries('Tensor Pipe Activity %', queries.gpuTensorActive, { x: 12, y: 19, w: 12, h: 8 }, unit='percent'),
  ]),

  g.panel.row.new('Pod GPU Allocation')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 3, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.table.gpuTablePanel('Pod GPU Allocation', queries.gpuCountByPod, { x: 0, y: 4, w: 24, h: 8 }),
    panels.timeSeries.gpuTimeSeries('GPU Memory Usage by Pod', queries.gpuMemoryByPod, { x: 0, y: 12, w: 12, h: 8 }, unit='mbytes'),
    panels.timeSeries.gpuTimeSeries('GPU Utilization by Pod', queries.gpuUtilizationByPod, { x: 12, y: 12, w: 12, h: 8 }, unit='percent'),
  ]),

  g.panel.row.new('GPU Health & Errors')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 4, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.gpuTimeSeries('Memory Pressure (>85% FB Used)', queries.gpuMemoryPressure, { x: 0, y: 5, w: 12, h: 8 }, unit='percentunit'),
    panels.timeSeries.gpuTimeSeries('Remapped Rows (ECC Errors)', [queries.gpuErrors, queries.gpuCorrectableErrors], { x: 12, y: 5, w: 12, h: 8 }),
  ]),
])
