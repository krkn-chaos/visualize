local panels = import '../../assets/node-overview/panels.libsonnet';
local queries = import '../../assets/node-overview/queries.libsonnet';
local variables = import '../../assets/node-overview/variables.libsonnet';
local ocpPanels = import '../../assets/ocp-performance/panels.libsonnet';
local ocpQueries = import '../../assets/ocp-performance/queries.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('Node Overview')
+ g.dashboard.withDescription('Real-time CPU, memory, disk I/O, and network metrics per cluster node. Filter by master / worker / infra role.')
+ g.dashboard.withTags(['krkn', 'nodes', 'infrastructure'])
+ g.dashboard.time.withFrom('now-1h')
+ g.dashboard.time.withTo('now')
+ g.dashboard.withTimezone('utc')
+ g.dashboard.timepicker.withRefreshIntervals(['5s', '10s', '30s', '1m', '5m', '15m', '30m', '1h'])
+ g.dashboard.withRefresh('30s')
+ g.dashboard.withEditable(true)
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.Datasource,
  variables.master_node,
  variables.worker_node,
  variables.infra_node,
  variables.block_device,
  variables.net_device,
  variables.namespace,
])

+ g.dashboard.withPanels([

  // ── Node Overview ────────────────────────────────────────────────────────────
  g.panel.row.new('Node Overview')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 }),

  panels.stat.node('Total Nodes', 'none', queries.totalNodes.query(), { x: 0, y: 1, w: 4, h: 3 }),
  panels.stat.node('Ready Nodes', 'none', queries.readyNodes.query(), { x: 4, y: 1, w: 4, h: 3 }),
  panels.stat.node('Masters', 'none', queries.masterCount.query(), { x: 8, y: 1, w: 4, h: 3 }),
  panels.stat.node('Workers', 'none', queries.workerCount.query(), { x: 12, y: 1, w: 4, h: 3 }),
  panels.stat.node('Infra', 'none', queries.infraCount.query(), { x: 16, y: 1, w: 4, h: 3 }),
  panels.stat.utilPercent('Cluster CPU Utilisation', queries.clusterCpuUtil.query(), { x: 20, y: 1, w: 4, h: 3 }),

  // ── CPU ─────────────────────────────────────────────────────────────────────
  g.panel.row.new('All Node Overview - CPU')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 4, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.withLegendRight('CPU Usage % per Node', 'percent', queries.cpuUsage.query(), { x: 0, y: 5, w: 24, h: 8 }),
    panels.timeSeries.withLegendRight('CPU by Mode', 'percent', queries.cpuByMode.query(), { x: 0, y: 13, w: 24, h: 8 }),
    panels.timeSeries.withLegend('Load Average 1m', 'short', queries.cpuLoad1.query(), { x: 0, y: 21, w: 12, h: 7 }),
    panels.timeSeries.withLegend('Load Average 5m', 'short', queries.cpuLoad5.query(), { x: 12, y: 21, w: 12, h: 7 }),
    panels.timeSeries.withLegend('I/O Wait %', 'percent', queries.cpuIowait.query(), { x: 0, y: 28, w: 24, h: 7 }),
  ]),

  // ── Memory ───────────────────────────────────────────────────────────────────
  g.panel.row.new('All Node Overview - Memory')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 5, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.withLegendRight('Memory Used', 'bytes', queries.memoryUsed.query(), { x: 0, y: 6, w: 12, h: 8 }),
    panels.timeSeries.withLegendRight('Memory Available', 'bytes', queries.memoryAvailable.query(), { x: 12, y: 6, w: 12, h: 8 }),
    panels.timeSeries.withLegendRight('Memory Utilisation %', 'percent', queries.memoryUtilPct.query(), { x: 0, y: 14, w: 24, h: 8 }),
    panels.timeSeries.withLegend('Memory Breakdown (active / cached+buf / free)', 'bytes', queries.memoryBreakdown.query(), { x: 0, y: 22, w: 24, h: 8 }),
  ]),

  // ── Disk I/O ─────────────────────────────────────────────────────────────────
  g.panel.row.new('All Node Overview - Disk I/O')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 6, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.withLegend('Read Throughput', 'Bps', queries.diskReadThroughput.query(), { x: 0, y: 7, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Write Throughput', 'Bps', queries.diskWriteThroughput.query(), { x: 12, y: 7, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Read IOPS', 'iops', queries.diskReadIOPS.query(), { x: 0, y: 15, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Write IOPS', 'iops', queries.diskWriteIOPS.query(), { x: 12, y: 15, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Read Latency (avg per op)', 's', queries.diskReadLatency.query(), { x: 0, y: 23, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Write Latency (avg per op)', 's', queries.diskWriteLatency.query(), { x: 12, y: 23, w: 12, h: 8 }),
  ]),

  // ── Network ──────────────────────────────────────────────────────────────────
  g.panel.row.new('All Node Overview - Network')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 7, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.timeSeries.withLegend('Receive Bandwidth', 'bps', queries.networkRxBps.query(), { x: 0, y: 8, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Transmit Bandwidth', 'bps', queries.networkTxBps.query(), { x: 12, y: 8, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Receive Packets/s', 'pps', queries.networkRxPackets.query(), { x: 0, y: 16, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Transmit Packets/s', 'pps', queries.networkTxPackets.query(), { x: 12, y: 16, w: 12, h: 8 }),
    panels.timeSeries.withLegend('Network Errors', 'short', queries.networkErrors.query(), { x: 0, y: 24, w: 12, h: 7 }),
    panels.timeSeries.withLegend('Network Drops', 'short', queries.networkDrops.query(), { x: 12, y: 24, w: 12, h: 7 }),
    panels.timeSeries.withLegend('TCP Retransmit Rate (latency proxy)', 'percentunit', queries.tcpRetransmitRate.query(), { x: 0, y: 31, w: 12, h: 7 }),
    panels.timeSeries.withLegend('Conntrack Utilisation %', 'percent', queries.conntrackUtilPct.query(), { x: 12, y: 31, w: 12, h: 7 }),
    panels.timeSeries.withLegend('Conntrack Entries vs Limit', 'short', queries.conntrackEntries.query(), { x: 0, y: 38, w: 24, h: 7 }),
  ]),

  // ── Per-Node Detail: Master ───────────────────────────────────────────────────
  g.panel.row.new('Master: $master_node')
  + g.panel.row.withGridPos({ x: 0, y: 8, w: 0, h: 8 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withRepeat('master_node')
  + g.panel.row.withPanels([
    ocpPanels.timeSeries.genericLegend('CPU Basic: $master_node', 'percent', ocpQueries.nodeCPU.query('$master_node'), { x: 0, y: 0, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('System Memory: $master_node', 'bytes', ocpQueries.nodeMemory.query('$master_node'), { x: 12, y: 0, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Disk Throughput: $master_node', 'Bps', ocpQueries.diskThroughput.query('$master_node'), { x: 0, y: 8, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Disk IOPS: $master_node', 'iops', ocpQueries.diskIOPS.query('$master_node'), { x: 12, y: 8, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Utilization: $master_node', 'bps', ocpQueries.networkUtilization.query('$master_node'), { x: 0, y: 16, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Packets: $master_node', 'pps', ocpQueries.networkPackets.query('$master_node'), { x: 12, y: 16, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Packets Drop: $master_node', 'pps', ocpQueries.networkDrop.query('$master_node'), { x: 0, y: 24, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('Conntrack Stats: $master_node', '', ocpQueries.conntrackStats.query('$master_node'), { x: 12, y: 24, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Top 10 Container CPU: $master_node', 'percent', ocpQueries.top10ContainerCPU.query('$master_node'), { x: 0, y: 32, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('Top 10 Container RSS: $master_node', 'bytes', ocpQueries.top10ContainerRSS.query('$master_node'), { x: 12, y: 32, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('CGroup CPU: $master_node', 'percent', ocpQueries.nodeCGroupCPU.query('$master_node'), { x: 0, y: 40, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('CGroup RSS: $master_node', 'bytes', ocpQueries.nodeCGroupRSS.query('$master_node'), { x: 12, y: 40, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Pod FS R/W Rate: $master_node', 'Bps', ocpQueries.containerReadWriteBytesPod.query('$master_node'), { x: 0, y: 48, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('CGroup FS R/W Rate: $master_node', 'Bps', ocpQueries.containerReadWriteBytesCGroup.query('$master_node'), { x: 12, y: 48, w: 12, h: 8 }),
  ]),

  // ── Per-Node Detail: Worker ───────────────────────────────────────────────────
  g.panel.row.new('Worker: $worker_node')
  + g.panel.row.withGridPos({ x: 0, y: 9, w: 0, h: 8 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withRepeat('worker_node')
  + g.panel.row.withPanels([
    ocpPanels.timeSeries.genericLegend('CPU Basic: $worker_node', 'percent', ocpQueries.nodeCPU.query('$worker_node'), { x: 0, y: 0, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('System Memory: $worker_node', 'bytes', ocpQueries.nodeMemory.query('$worker_node'), { x: 12, y: 0, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Disk Throughput: $worker_node', 'Bps', ocpQueries.diskThroughput.query('$worker_node'), { x: 0, y: 8, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Disk IOPS: $worker_node', 'iops', ocpQueries.diskIOPS.query('$worker_node'), { x: 12, y: 8, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Utilization: $worker_node', 'bps', ocpQueries.networkUtilization.query('$worker_node'), { x: 0, y: 16, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Packets: $worker_node', 'pps', ocpQueries.networkPackets.query('$worker_node'), { x: 12, y: 16, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Packets Drop: $worker_node', 'pps', ocpQueries.networkDrop.query('$worker_node'), { x: 0, y: 24, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('Conntrack Stats: $worker_node', '', ocpQueries.conntrackStats.query('$worker_node'), { x: 12, y: 24, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Top 10 Container CPU: $worker_node', 'percent', ocpQueries.top10ContainerCPU.query('$worker_node'), { x: 0, y: 32, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('Top 10 Container RSS: $worker_node', 'bytes', ocpQueries.top10ContainerRSS.query('$worker_node'), { x: 12, y: 32, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('CGroup CPU: $worker_node', 'percent', ocpQueries.nodeCGroupCPU.query('$worker_node'), { x: 0, y: 40, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('CGroup RSS: $worker_node', 'bytes', ocpQueries.nodeCGroupRSS.query('$worker_node'), { x: 12, y: 40, w: 12, h: 8 }),
  ]),

  // ── Per-Node Detail: Infra ────────────────────────────────────────────────────
  g.panel.row.new('Infra: $infra_node')
  + g.panel.row.withGridPos({ x: 0, y: 10, w: 0, h: 8 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withRepeat('infra_node')
  + g.panel.row.withPanels([
    ocpPanels.timeSeries.genericLegend('CPU Basic: $infra_node', 'percent', ocpQueries.nodeCPU.query('$infra_node'), { x: 0, y: 0, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('System Memory: $infra_node', 'bytes', ocpQueries.nodeMemory.query('$infra_node'), { x: 12, y: 0, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Disk Throughput: $infra_node', 'Bps', ocpQueries.diskThroughput.query('$infra_node'), { x: 0, y: 8, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Disk IOPS: $infra_node', 'iops', ocpQueries.diskIOPS.query('$infra_node'), { x: 12, y: 8, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Utilization: $infra_node', 'bps', ocpQueries.networkUtilization.query('$infra_node'), { x: 0, y: 16, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Packets: $infra_node', 'pps', ocpQueries.networkPackets.query('$infra_node'), { x: 12, y: 16, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Network Packets Drop: $infra_node', 'pps', ocpQueries.networkDrop.query('$infra_node'), { x: 0, y: 24, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('Conntrack Stats: $infra_node', '', ocpQueries.conntrackStats.query('$infra_node'), { x: 12, y: 24, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegend('Top 10 Container CPU: $infra_node', 'percent', ocpQueries.top10ContainerCPU.query('$infra_node'), { x: 0, y: 32, w: 12, h: 8 }),
    ocpPanels.timeSeries.genericLegendCounter('Top 10 Container RSS: $infra_node', 'bytes', ocpQueries.top10ContainerRSS.query('$infra_node'), { x: 12, y: 32, w: 12, h: 8 }),
  ]),

])
