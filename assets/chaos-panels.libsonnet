local commonOverrides = [
  { matcher: { id: 'byName', options: '_type' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: '_id' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: '_index' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: 'kubernetes_objects' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: 'kubernetes_objects_count.Deployment' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: 'kubernetes_objects_count.ConfigMap' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: 'kubernetes_objects_count.Build' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: 'kubernetes_objects_count.Pod' }, properties: [{ id: 'custom.hidden', value: true }] },
  { matcher: { id: 'byName', options: 'kubernetes_objects_count.Route' }, properties: [{ id: 'custom.hidden', value: true }] },
];

{
  scenarioDetailsRow():: {
    collapsed: false,
    gridPos: { h: 1, w: 24, x: 0, y: 0 },
    id: 20,
    panels: [],
    title: 'Scenario Details',
    type: 'row',
  },

  scenarioUuidDetails(title, query):: {
    datasource: { type: 'grafana-opensearch-datasource', uid: '${Datasource}' },
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        custom: { align: 'auto', cellOptions: { type: 'auto' }, inspect: false },
        mappings: [],
        thresholds: { mode: 'absolute', steps: [{ color: 'green', value: null }, { color: 'red', value: 80 }] },
      },
      overrides: commonOverrides,
    },
    gridPos: { h: 10, w: 24, x: 0, y: 1 },
    id: 1,
    options: {
      cellHeight: 'sm',
      footer: { countRows: false, fields: '', reducer: ['sum'], show: false },
      frameIndex: 1,
      showHeader: true,
      sortBy: [{ desc: true, displayName: 'scenarios' }],
    },
    pluginVersion: '10.4.0',
    targets: [{
      alias: '',
      bucketAggs: [],
      datasource: { type: 'grafana-opensearch-datasource', uid: '${Datasource}' },
      metrics: [{ id: '1', settings: { size: '500' }, type: 'raw_data' }],
      query: query,
      refId: 'A',
      timeField: 'timestamp',
    }],
    title: title,
    type: 'table',
  },

  telemetryRow(y, id):: {
    collapsed: false,
    gridPos: { h: 1, w: 24, x: 0, y: y },
    id: id,
    panels: [],
    title: 'Cluster Telemetry',
    type: 'row',
  },

  alertsRow():: {
    collapsed: false,
    gridPos: { h: 1, w: 24, x: 0, y: 11 },
    id: 21,
    panels: [],
    title: 'Alerts',
    type: 'row',
  },

  consoleHealthCheck(y=29):: {
    datasource: { type: 'grafana-opensearch-datasource', uid: '${Metrics}' },
    fieldConfig: {
      defaults: {
        color: { mode: 'palette-classic' },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: 'Status Code',
          axisPlacement: 'auto',
          axisSoftMin: 100,
          axisSoftMax: 515,
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 90,
          gradientMode: 'none',
          hideFrom: { graph: false, legend: false, tooltip: false, viz: false },
          lineInterpolation: 'stepAfter',
          lineStyle: { fill: 'solid' },
          lineWidth: 2,
          pointSize: 8,
          scaleDistribution: { type: 'linear' },
          showPoints: 'always',
          spanNulls: false,
          stacking: { group: 'A', mode: 'none' },
          thresholdsStyle: { mode: 'off' },
        },
        mappings: [{
          type: 'value',
          options: {
            '200': { text: 'UP (200)' },
            '500': { text: 'DOWN (500)' },
            '503': { text: 'DOWN (503)' },
          },
        }],
        thresholds: { mode: 'absolute', steps: [{ color: 'green', value: null }] },
        unit: 'none',
      },
      overrides: [],
    },
    gridPos: { h: 19, w: 24, x: 0, y: y },
    id: 66,
    maxDataPoints: 1000,
    options: {
      legend: {
        calcs: ['min', 'max', 'mean', 'lastNotNull'],
        displayMode: 'table',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: { hideZeros: false, mode: 'multi', sort: 'desc' },
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '{{term run_uuid.keyword}}',
        bucketAggs: [
          { field: 'run_uuid.keyword', id: '3', settings: { min_doc_count: '1', order: 'desc', orderBy: '_term', size: '10' }, type: 'terms' },
          { field: 'start_timestamp', id: '2', settings: { interval: 'auto', min_doc_count: '1', timeZone: 'utc', trimEdges: '0' }, type: 'date_histogram' },
        ],
        datasource: { type: 'grafana-opensearch-datasource', uid: '${Metrics}' },
        hide: false,
        metrics: [{ field: 'status_code', id: '1', type: 'max' }],
        query: 'run_uuid.keyword: $run_uuid AND metricName: health_check_recovery',
        refId: 'A',
        timeField: 'start_timestamp',
      },
      {
        alias: '{{term run_uuid.keyword}}',
        bucketAggs: [
          { field: 'run_uuid.keyword', id: '6', settings: { min_doc_count: '1', order: 'desc', orderBy: '_term', size: '10' }, type: 'terms' },
          { field: 'end_timestamp', id: '5', settings: { interval: 'auto', min_doc_count: '1', timeZone: 'utc', trimEdges: '0' }, type: 'date_histogram' },
        ],
        datasource: { type: 'grafana-opensearch-datasource', uid: '${Metrics}' },
        hide: false,
        metrics: [{ field: 'status_code', id: '4', type: 'max' }],
        query: 'run_uuid.keyword: $run_uuid AND metricName: health_check_recovery',
        refId: 'B',
        timeField: 'start_timestamp',
      },
    ],
    title: 'Console Health Check - Status & Downtime',
    transformations: [
      { id: 'seriesToRows', options: {} },
      { id: 'merge', options: {} },
      { id: 'partitionByValues', options: { fields: ['Metric'], keepLabels: false } },
    ],
    type: 'timeseries',
  },

  scenarioAlerts():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Alerts}',
    },
    fieldConfig: {
      defaults: {
        color: {
          mode: 'thresholds',
        },
        custom: {
          align: 'auto',
          cellOptions: {
            type: 'auto',
          },
          inspect: false,
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [
        {
          matcher: {
            id: 'byName',
            options: '_type',
          },
          properties: [
            {
              id: 'custom.width',
              value: 28,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: '_index',
          },
          properties: [
            {
              id: 'custom.width',
              value: 115,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: '_id',
          },
          properties: [
            {
              id: 'custom.width',
              value: 172,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'created_at',
          },
          properties: [
            {
              id: 'custom.width',
              value: 173,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'alert',
          },
          properties: [
            {
              id: 'custom.width',
              value: 870,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: '_id',
          },
          properties: [
            {
              id: 'custom.hidden',
              value: true,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: '_index',
          },
          properties: [
            {
              id: 'custom.hidden',
              value: true,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: '_type',
          },
          properties: [
            {
              id: 'custom.hidden',
              value: true,
            },
          ],
        },
      ],
    },
    gridPos: {
      h: 8,
      w: 24,
      x: 0,
      y: 11,
    },
    id: 6,
    options: {
      cellHeight: 'sm',
      footer: {
        countRows: false,
        fields: '',
        reducer: [
          'sum',
        ],
        show: false,
      },
      frameIndex: 0,
      showHeader: true,
      sortBy: [
        {
          desc: false,
          displayName: 'severity',
        },
      ],
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '',
        bucketAggs: [],
        datasource: {
          type: 'grafana-opensearch-datasource',
          uid: '${Alerts}',
        },
        format: 'table',
        luceneQueryType: 'Metric',
        metrics: [
          {
            id: '1',
            settings: {
              order: 'desc',
              size: '500',
              useTimeRange: true,
            },
            type: 'raw_data',
          },
        ],
        query: 'run_uuid: $run_uuid',
        queryType: 'lucene',
        refId: 'A',
        timeField: 'created_at',
      },
    ],
    title: 'Alerts for UUIDs',
    type: 'table',
  },
}