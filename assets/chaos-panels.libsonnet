{
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