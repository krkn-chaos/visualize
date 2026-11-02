local panels = import '../../assets/pvc-utilization/panels.libsonnet';
local queries = import '../../assets/pvc-utilization/queries.libsonnet';
local variables = import '../../assets/pvc-utilization/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('PVC Utilization')
+ g.dashboard.withDescription('Live Kubernetes PVC usage from kubelet volume statistics and VMI guest filesystem usage from KubeVirt guest metrics in Prometheus.')
+ g.dashboard.withTags(['kubernetes', 'storage', 'pvc', 'prometheus'])
+ g.dashboard.time.withFrom('now-1h')
+ g.dashboard.time.withTo('now')
+ g.dashboard.withTimezone('utc')
+ g.dashboard.timepicker.withRefreshIntervals(['5s', '10s', '30s', '1m', '5m', '15m', '1h'])
+ g.dashboard.withRefresh('30s')
+ g.dashboard.withEditable(true)
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.Datasource,
  variables.namespace,
  variables.pvc,
  variables.vmi,
  variables.mountPoint,
])
+ g.dashboard.withPanels([
  g.panel.row.new('Cluster PVC Summary')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 }),

  panels.stat('PVCs Selected', 'short', queries.pvcCount.query(), { x: 0, y: 1, w: 4, h: 4 }),
  panels.stat('Total Used', 'bytes', queries.totalUsed.query(), { x: 4, y: 1, w: 5, h: 4 }),
  panels.stat('Reported Capacity', 'bytes', queries.totalCapacity.query(), { x: 9, y: 1, w: 5, h: 4 }),
  panels.stat('Requested Capacity', 'bytes', queries.totalRequestedCapacity.query(), { x: 14, y: 1, w: 5, h: 4 }),
  panels.stat('Overall Utilization', 'percent', queries.clusterUtilization.query(), { x: 19, y: 1, w: 5, h: 4 }),

  g.panel.row.new('PVC Utilization Over Time')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 5, w: 24, h: 1 }),

  panels.timeSeries('Utilization by PVC', 'percent', queries.utilizationByPvc.query(), { x: 0, y: 6, w: 24, h: 8 }),
  panels.timeSeries('Used Space by PVC', 'bytes', queries.usedByPvc.query(), { x: 0, y: 14, w: 12, h: 8 }),
  panels.timeSeries('Available Space by PVC', 'bytes', queries.availableByPvc.query(), { x: 12, y: 14, w: 12, h: 8 }),
  panels.timeSeries('Requested Storage by PVC', 'bytes', queries.requestedCapacityByPvc.query(), { x: 0, y: 22, w: 24, h: 8 }),

  g.panel.row.new('VMI Guest Filesystem Usage (guest agent required)')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 30, w: 24, h: 1 }),

  panels.timeSeries('Guest Filesystem Utilization by VMI', 'percent', queries.guestFilesystemUtilizationByVmi.query(), { x: 0, y: 31, w: 24, h: 8 }),
  panels.timeSeries('Guest Filesystem Used by VMI', 'bytes', queries.guestFilesystemUsedByVmi.query(), { x: 0, y: 39, w: 12, h: 8 }),
  panels.timeSeries('Guest Filesystem Capacity by VMI', 'bytes', queries.guestFilesystemCapacityByVmi.query(), { x: 12, y: 39, w: 12, h: 8 }),
])
