local panels = import '../../assets/kv-perf/panels.libsonnet';
local queries = import '../../assets/kv-perf/queries.libsonnet';
local variables = import '../../assets/kv-perf/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('KV Performance')
+ g.dashboard.withDescription(|||
  Performance dashboard for Red Hat KV
|||)
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
  variables.master_node,
  variables.worker_node,
  variables.infra_node,
  variables.namespace,
  variables.block_device,
  variables.net_device,
  variables.interval,
])
+ g.dashboard.withPanels([
  g.panel.row.new('Cluster-at-a-Glance')
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withPanels([
    panels.timeSeries.genericLegend('Workers CPU Usage', 'percent', queries.workersCPU.query(), { x: 0, y: 2, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Control Plane CPU Usage', 'percent', queries.controlPlanesCPU.query(), { x: 12, y: 2, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Workers Load1', 'short', queries.workersLoad1.query(), { x: 0, y: 9, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Control Plane Load1', 'short', queries.controlPlanesLoad1.query(), { x: 12, y: 9, w: 12, h: 8 }),
  ]),
  g.panel.row.new('OVN')
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withPanels([
    panels.timeSeries.genericLegend('ovnkube-control-plane CPU Usage', 'percent', queries.ovnKubeControlPlaneCPU.query(), { x: 0, y: 1, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('ovnkube-control-plane Memory Usage', 'bytes', queries.ovnKubeControlPlaneMem.query(), { x: 12, y: 1, w: 12, h: 8 }),
   
  ]),
  g.panel.row.new('Cluster Details')
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withPanels([
    panels.stat.base('Current Node Count', queries.currentNodeCount.query(), { x: 0, y: 4, w: 8, h: 3 }),
    panels.stat.base('Current Namespace Count', queries.currentNamespaceCount.query(), { x: 8, y: 4, w: 8, h: 3 }),
    panels.stat.base('Current Pod Count', queries.currentPodCount.query(), { x: 16, y: 4, w: 8, h: 3 }),
    panels.timeSeries.generic('Number of nodes', 'none', queries.currentNodeCount.query(), { x: 0, y: 12, w: 8, h: 8 }),
    panels.timeSeries.generic('Namespace count', 'none', queries.nsCount.query(), { x: 8, y: 12, w: 8, h: 8 }),
    panels.timeSeries.generic('Pod count', 'none', queries.podCount.query(), { x: 16, y: 12, w: 8, h: 8 }),
    panels.timeSeries.generic('Secret & configmap count', 'none', queries.secretCmCount.query(), { x: 0, y: 20, w: 8, h: 8 }),
    panels.timeSeries.generic('Deployment count', 'none', queries.deployCount.query(), { x: 8, y: 20, w: 8, h: 8 }),
    panels.timeSeries.generic('Services count', 'none', queries.servicesCount.query(), { x: 16, y: 20, w: 8, h: 8 }),
    panels.timeSeries.generic('Routes count', 'none', queries.routesCount.query(), { x: 0, y: 20, w: 8, h: 8 }),
    panels.timeSeries.generic('Alerts', 'none', queries.alerts.query(), { x: 8, y: 20, w: 8, h: 8 }),
    panels.timeSeries.genericLegend('Pod Distribution', 'none', queries.podDistribution.query(), { x: 16, y: 20, w: 8, h: 8 }),
    panels.timeSeries.genericLegend('Top 10 container RSS', 'bytes', queries.top10ContMem.query(), { x: 0, y: 28, w: 24, h: 8 }),
    panels.timeSeries.genericLegend('container RSS system.slice', 'bytes', queries.contMemRSSSystemSlice.query(), { x: 12, y: 28, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Top 10 container CPU', 'percent', queries.top10ContCPU.query(), { x: 0, y: 36, w: 12, h: 8 }),
    panels.timeSeries.generic('Goroutines count', 'none', queries.goroutinesCount.query(), { x: 12, y: 36, w: 12, h: 8 }),
  ]),
  g.panel.row.new('Cluster Operators Details')
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withPanels([
    panels.stat.base('Cluster operators overview', queries.clusterOperatorsOverview.query(), { x: 0, y: 4, w: 24, h: 3 }),
    panels.timeSeries.genericLegend('Cluster operators information', 'none', queries.clusterOperatorsInformation.query(), { x: 0, y: 4, w: 8, h: 8 }),
    panels.timeSeries.genericLegend('Cluster operators degraded', 'none', queries.clusterOperatorsDegraded.query(), { x: 8, y: 4, w: 8, h: 8 }),
  ]),
  g.panel.row.new('Worker: $_worker_node')
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 0, h: 8 })
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withRepeat('_worker_node')
  + g.panel.row.withPanels([
    panels.timeSeries.genericLegend('CPU Basic: $_worker_node', 'percent', queries.nodeCPU.query('$_worker_node'), { x: 0, y: 0, w: 12, h: 8 }),
    panels.timeSeries.genericLegendCounter('System Memory: $_worker_node', 'bytes', queries.nodeMemory.query('$_worker_node'), { x: 12, y: 0, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Disk throughput: $_worker_node', 'Bps', queries.diskThroughput.query('$_worker_node'), { x: 0, y: 8, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Disk IOPS: $_worker_node', 'iops', queries.diskIOPS.query('$_worker_node'), { x: 12, y: 8, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Network Utilization: $_worker_node', 'bps', queries.networkUtilization.query('$_worker_node'), { x: 0, y: 16, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Network Packets: $_worker_node', 'pps', queries.networkPackets.query('$_worker_node'), { x: 12, y: 16, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Network packets drop: $_worker_node', 'pps', queries.networkDrop.query('$_worker_node'), { x: 0, y: 24, w: 12, h: 8 }),
    panels.timeSeries.genericLegendCounter('Conntrack stats: $_worker_node', '', queries.conntrackStats.query('$_worker_node'), { x: 12, y: 24, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('Top 10 container CPU: $_worker_node', 'percent', queries.top10ContainerCPU.query('$_worker_node'), { x: 0, y: 32, w: 12, h: 8 }),
    panels.timeSeries.genericLegendCounter('Top 10 container RSS: $_worker_node', 'bytes', queries.top10ContainerRSS.query('$_worker_node'), { x: 12, y: 32, w: 12, h: 8 }),
    panels.timeSeries.genericLegend('cgroup CPU: $_worker_node', 'percent', queries.nodeCGroupCPU.query('$_worker_node'), { x: 0, y: 40, w: 12, h: 8 }),
    panels.timeSeries.genericLegendCounter('cgroup RSS: $_worker_node', 'bytes', queries.nodeCGroupRSS.query('$_worker_node'), { x: 12, y: 40, w: 12, h: 8 }),
  ]),
])
