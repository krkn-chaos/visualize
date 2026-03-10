local chaos_panels = import '../chaos-panels.libsonnet';
local metrics_panels = import '../metrics-panels.libsonnet';
local queries = import 'queries.libsonnet';

local timeseriesPanel(id, title, description, query, unit='short', gridX=0, gridY=21, gridW=12) = {
  datasource: { type: 'grafana-opensearch-datasource', uid: '${Metrics}' },
  description: description,
  fieldConfig: {
    defaults: {
      color: { mode: 'palette-classic' },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 0,
        gradientMode: 'none',
        hideFrom: { legend: false, tooltip: false, viz: false },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: { type: 'linear' },
        showPoints: 'auto',
        spanNulls: false,
        stacking: { group: 'A', mode: 'none' },
        thresholdsStyle: { mode: 'off' },
      },
      mappings: [],
      thresholds: { mode: 'absolute', steps: [{ color: 'green', value: null }] },
      unit: unit,
    },
    overrides: [],
  },
  gridPos: { h: 8, w: gridW, x: gridX, y: gridY },
  id: id,
  options: {
    legend: { calcs: [], displayMode: 'list', placement: 'bottom', showLegend: true },
    tooltip: { mode: 'single', sort: 'none' },
  },
  pluginVersion: '10.4.0',
  targets: [{
    alias: '',
    bucketAggs: [
      { field: 'run_uuid.keyword', id: '2', settings: { min_doc_count: '1', order: 'desc', orderBy: '_term', size: '10' }, type: 'terms' },
      { field: 'timestamp', id: '3', settings: { interval: 'auto', min_doc_count: '0', timeZone: 'utc', trimEdges: '0' }, type: 'date_histogram' },
    ],
    datasource: { type: 'grafana-opensearch-datasource', uid: '${Metrics}' },
    metrics: [{ field: 'value', id: '1', meta: { avg: true }, settings: {}, type: 'extended_stats' }],
    query: query,
    refId: 'A',
    timeField: 'timestamp',
  }],
  title: title,
  type: 'timeseries',
};

{
  // synFloodMetricsRow():: {
  //   collapsed: false,
  //   gridPos: { h: 1, w: 24, x: 0, y: 20 },
  //   id: 22,
  //   panels: [],
  //   title: 'SYN Flood Metrics',
  //   type: 'row',
  // },

  getAllPanels():: [
    chaos_panels.scenarioDetailsRow(),
    chaos_panels.scenarioUuidDetails('SYN Flood Scenario UUID Details', queries.synFloodScenarioUuidDetails),
    chaos_panels.alertsRow(),
    chaos_panels.scenarioAlerts(),
    // self.synFloodMetricsRow(),
    timeseriesPanel(2, 'Active Connection Count During Flood', 'Number of SYN connections established during the flood attack.', queries.connectionCount, 'short', 0, 21, 12),
    timeseriesPanel(3, 'Service Recovery Time', 'Time for the targeted service to recover after the SYN flood.', queries.serviceRecoveryTime, 's', 12, 21, 12),
    chaos_panels.consoleHealthCheck(29),
    chaos_panels.telemetryRow(48, 23),
    metrics_panels.etcd99thWalFsyncLatency(),
    metrics_panels.etcd99thRoundTripTime(),
    metrics_panels.ovnMasterCPU(),
    metrics_panels.ovnMasterMemUsage(),
    metrics_panels.ovnCPUUsage(),
    metrics_panels.apiInflightRequests(),
    metrics_panels.maxMemoryKubelet(),
    metrics_panels.cpuKubelet(),
    metrics_panels.mastersMemoryUsageGauge(),
  ],
}
