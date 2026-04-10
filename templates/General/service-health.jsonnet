local panels = import '../../assets/service-health/panels.libsonnet';
local queries = import '../../assets/service-health/queries.libsonnet';
local variables = import '../../assets/service-health/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new('OpenShift Service Health')
+ g.dashboard.withDescription('Live status of services, pods, and deployments by namespace')
+ g.dashboard.withTags(['krkn', 'openshift', 'services', 'health'])
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
])

+ g.dashboard.withPanels([

  // ── Summary ───────────────────────────────────────────────────────────────────
  g.panel.row.new('Summary')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 0, w: 24, h: 1 }),

  panels.stat.healthy('Total Services', queries.servicesTotal.query(), { x: 0, y: 1, w: 4, h: 3 }),
  panels.stat.healthy('Total Routes', queries.routesTotal.query(), { x: 4, y: 1, w: 4, h: 3 }),
  panels.stat.healthy('Pods Ready', queries.podsReady.query(), { x: 8, y: 1, w: 4, h: 3 }),
  panels.stat.unhealthy('Pods Not Ready', queries.podsNotReady.query(), { x: 12, y: 1, w: 4, h: 3 }),
  panels.stat.healthy('Deployments Healthy', queries.deploymentsHealthy.query(), { x: 16, y: 1, w: 4, h: 3 }),
  panels.stat.unhealthy('Deployments Degraded', queries.deploymentsDegraded.query(), { x: 20, y: 1, w: 4, h: 3 }),

  // ── Services ──────────────────────────────────────────────────────────────────
  g.panel.row.new('Services')
  + g.panel.row.withCollapsed(false)
  + g.panel.row.withGridPos({ x: 0, y: 4, w: 24, h: 1 }),

  panels.table.serviceInfo(
    'Service List',
    queries.serviceTable.query(),
    { x: 0, y: 5, w: 24, h: 10 }
  ),

  // ── Routes ────────────────────────────────────────────────────────────────────
  g.panel.row.new('Routes')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 15, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.table.routeStatus(
      'Route Status',
      queries.routeStatusTable.query(),
      { x: 0, y: 16, w: 24, h: 10 }
    ),
  ]),

  // ── Pods ──────────────────────────────────────────────────────────────────────
  g.panel.row.new('Pods')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 22, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.table.podStatus(
      'Pod Status',
      queries.podPhaseTable.query() + queries.podReadyTable.query(),
      { x: 0, y: 23, w: 24, h: 10 }
    ),
    panels.timeSeries.base(
      'Pod Phases Over Time',
      'short',
      queries.podPhasesOverTime.query(),
      { x: 0, y: 33, w: 24, h: 7 }
    ),
  ]),

  // ── Deployments ───────────────────────────────────────────────────────────────
  g.panel.row.new('Deployments')
  + g.panel.row.withCollapsed(true)
  + g.panel.row.withGridPos({ x: 0, y: 23, w: 24, h: 1 })
  + g.panel.row.withPanels([
    panels.table.deploymentStatus(
      'Deployment Replica Status',
      queries.deploymentDesired.query() + queries.deploymentAvailable.query() + queries.deploymentUnavailable.query(),
      { x: 0, y: 24, w: 24, h: 10 }
    ),
    panels.timeSeries.base(
      'Deployments with Unavailable Replicas Over Time',
      'short',
      queries.deploymentUnavailableOverTime.query(),
      { x: 0, y: 34, w: 24, h: 7 }
    ),
  ]),

])
