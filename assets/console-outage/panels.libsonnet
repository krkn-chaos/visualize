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
          axisLabel: 'Status Code',
          axisPlacement: 'auto',
          axisSoftMin: 150,
          axisSoftMax: 550,
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 90,
          gradientMode: 'none',
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
          lineWidth: 2,
          pointSize: 8,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'always',
          spanNulls: true,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [
          {
            type: 'value',
            options: {
              '200': {
                text: 'UP (200)',
              },
              '500': {
                text: 'DOWN (500)',
              },
              '503': {
                text: 'DOWN (503)',
              },
            },
          },
        ],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
          ],
        },
        unit: 'none',
      },
      overrides: [],
    },
    gridPos: {
      h: 19,
      w: 24,
      x: 0,
      y: 0,
    },
    id: 66,
    maxDataPoints: 1000,
    options: {
      legend: {
        calcs: [
          'min',
          'max',
          'mean',
          'lastNotNull',
        ],
        displayMode: 'table',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        hideZeros: false,
        mode: 'multi',
        sort: 'desc',
      },
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '{{term run_uuid.keyword}}',
        bucketAggs: [
          {
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '10',
            },
            type: 'terms',
          },
          {
            field: 'start_timestamp',
            id: '2',
            settings: {
              interval: 'auto',
              min_doc_count: '1',
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
        hide: false,
        metrics: [
          {
            field: 'status_code',
            id: '1',
            type: 'max',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName: health_check_recovery',
        refId: 'A',
        timeField: 'start_timestamp',
      },
    ],
    title: 'Console Health Check - Status & Downtime',
    type: 'timeseries',
  },

  downtimeDurationByEvent():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    fieldConfig: {
      defaults: {
        custom: {
          drawStyle: 'bars',
          lineInterpolation: 'linear',
          barAlignment: 0,
          lineWidth: 1,
          fillOpacity: 80,
          gradientMode: 'none',
          spanNulls: false,
          showPoints: 'never',
          pointSize: 5,
          stacking: {
            mode: 'none',
            group: 'A',
          },
          axisPlacement: 'auto',
          axisLabel: '',
          scaleDistribution: {
            type: 'linear',
          },
          hideFrom: {
            tooltip: false,
            viz: false,
            legend: false,
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        color: {
          mode: 'palette-classic',
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              value: null,
              color: 'red',
            },
          ],
        },
        unit: 's',
      },
      overrides: [],
    },
    gridPos: {
      h: 9,
      w: 24,
      x: 0,
      y: 27,
    },
    id: 68,
    options: {
      tooltip: {
        mode: 'multi',
        sort: 'desc',
      },
      legend: {
        showLegend: true,
        displayMode: 'table',
        placement: 'bottom',
        calcs: [
          'sum',
          'max',
          'mean',
          'count',
        ],
      },
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '{{term run_uuid.keyword}}',
        bucketAggs: [
          {
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '10',
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
            field: 'duration',
            id: '1',
            type: 'max',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName: health_check_recovery AND status: false',
        refId: 'A',
        timeField: 'start_timestamp',
      },
    ],
    title: 'Downtime Duration by Outage Event',
    type: 'timeseries',
    description: 'Shows the duration (in seconds) of each downtime event. Each bar represents one outage period. Grouped by run UUID.',
  },

  getAllPanels():: [
    self.consoleDownTime(),
    self.downtimeDurationByEvent(),
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
