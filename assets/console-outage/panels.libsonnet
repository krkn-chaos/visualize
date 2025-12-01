local chaos_panels = import '../chaos-panels.libsonnet';
local panels = import '../metrics-panels.libsonnet';
local queries = import 'queries.libsonnet';

{
  consoleDownTime():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          axisSoftMax: 550,
          axisSoftMin: 0,
          axisWidth: 83,
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 10,
          gradientMode: 'opacity',
          hideFrom: {
            graph: false,
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'smooth',
          lineStyle: {
            fill: 'solid',
          },
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'always',
          spanNulls: true,
          stacking: {
            group: 'A',
            mode: 'normal',
          },
          thresholdsStyle: {
            mode: 'area',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'blue',
              value: null,
            },
            {
              color: '#EAB839',
              value: 500,
            },
            {
              color: 'red',
              value: 503,
            },
          ],
        },
        unit: 'degree',
      },
      overrides: [
        {
          matcher: {
            id: 'byFrameRefID',
            options: 'A',
          },
          properties: [
            {
              id: 'custom.showPoints',
              value: 'auto',
            },
          ],
        },
      ],
    },
    gridPos: {
      h: 19,
      w: 24,
      x: 0,
      y: 0,
    },
    id: 66,
    maxDataPoints: 200,
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        hideZeros: false,
        mode: 'multi',
        sort: 'asc',
      },
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '',
        bucketAggs: [
          {
            field: 'run_uuid.keyword',
            id: '4',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'start_timestamp',
            id: '2',
            settings: {
              interval: 'auto',
              min_doc_count: '0',
              timeZone: 'utc',
              trimEdges: '0',
            },
            type: 'date_histogram',
          },
        ],
        datasource: {
          type: 'grafana-opensearch-datasource',
          uid: '${Metrics}',
        },
        metrics: [
          {
            field: 'status_code',
            id: '1',
            meta: {
              avg: true,
              std_deviation_bounds_lower: false,
              std_deviation_bounds_upper: false,
            },
            settings: {},
            type: 'extended_stats',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName: health_check_recovery',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Console Health Check',
    type: 'timeseries',
  },

  getAllPanels():: [
    self.consoleDownTime(),
    chaos_panels.scenarioAlerts(),
    panels.etcd99thWalFsyncLatency(),
    panels.etcd99thRoundTripTime(),
    panels.ovnMasterCPU(),
    panels.ovnMasterMemUsage(),
    panels.ovnCPUUsage(),
    panels.apiInflightRequests(),
    panels.maxMemoryKubelet(),
    panels.cpuKubelet(),
    panels.mastersMemoryUsageGauge(),
  ],
}
