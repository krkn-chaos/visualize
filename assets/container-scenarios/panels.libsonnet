local chaos_panels = import '../chaos-panels.libsonnet';
local panels = import '../metrics-panels.libsonnet';
local queries = import 'queries.libsonnet';
{
  scenarioDetailsRow():: {
    collapsed: false,
    gridPos: { h: 1, w: 24, x: 0, y: 0 },
    id: 17,
    panels: [],
    title: 'Scenario Details',
    type: 'row',
  },

  containerScenarioUuidDetails():: {
    datasource: {
      type: 'elasticsearch',
      uid: '${Datasource}',
    },
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        custom: {
          align: 'auto',
          cellOptions: { type: 'auto' },
          inspect: false,
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 80 },
          ],
        },
      },
      overrides: [],
    },
    gridPos: { h: 10, w: 24, x: 0, y: 1 },
    id: 2,
    options: {
      cellHeight: 'sm',
      footer: {
        countRows: false,
        fields: '',
        reducer: ['sum'],
        show: false,
      },
      frameIndex: 1,
      showHeader: true,
      sortBy: [
        { desc: true, displayName: 'scenarios' },
      ],
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '',
        bucketAggs: [],
        datasource: { type: 'elasticsearch', uid: '${Datasource}' },
        metrics: [
          { id: '1', settings: { size: '500' }, type: 'raw_data' },
        ],
        query: queries.containerScenarioUuidDetails,
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Container Scenario UUID Details',
    type: 'table',
  },

  etcdRecoveryTime():: {
    datasource: {
      type: 'elasticsearch',
      uid: '${Datasource}',
    },
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
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
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          insertNulls: false,
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
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
        unit: 'short',
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 24,
      x: 12,
      y: 27,
    },
    id: 3,
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '',
        bucketAggs: [
          {
            field: 'cluster_version.keyword',
            id: '2',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '10',
            },
            type: 'terms',
          },
          {
            field: 'run_uuid.keyword',
            id: '4',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '10',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '3',
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
          type: 'elasticsearch',
          uid: '${Metrics}',
        },
        metrics: [
          {
            field: 'scenarios.affected_pods.recovered.total_recovery_time',
            id: '1',
            meta: {
              avg: true,
              min: false,
              std_deviation_bounds_lower: false,
              std_deviation_bounds_upper: false,
            },
            settings: {},
            type: 'extended_stats',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.scenarios.namespace: "openshift-etcd"',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Openshift ETCD Recovery Time',
    type: 'timeseries',
  },

  unrecoveredContainers():: {
    datasource: {
      type: 'elasticsearch',
      uid: '${Metrics}',
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
        {
          matcher: {
            id: 'byName',
            options: 'highlight',
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
            id: 'byRegexp',
            options: '/.objects_count*/',
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
            options: 'sort',
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
            options: 'cloud_infrastructure',
          },
          properties: [
            {
              id: 'custom.width',
              value: 65,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'cloud_type',
          },
          properties: [
            {
              id: 'custom.width',
              value: 116,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'cluster_version',
          },
          properties: [
            {
              id: 'custom.width',
              value: 215,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'node_summary_infos',
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
            options: 'node_taints',
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
            options: 'network_plugins',
          },
          properties: [
            {
              id: 'custom.width',
              value: 175,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'scenarios',
          },
          properties: [
            {
              id: 'custom.width',
              value: 821,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'timestamp',
          },
          properties: [
            {
              id: 'custom.width',
              value: 152,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'run_uuid',
          },
          properties: [
            {
              id: 'custom.width',
              value: 304,
            },
          ],
        },
      ],
    },
    gridPos: {
      h: 8,
      w: 24,
      x: 0,
      y: 35,
    },
    id: 5,
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
      showHeader: true,
      sortBy: [
        {
          desc: false,
          displayName: 'timestamp',
        },
      ],
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '',
        bucketAggs: [],
        datasource: {
          type: 'elasticsearch',
          uid: '${Metrics}',
        },
        metrics: [
          {
            id: '1',
            settings: {
              size: '500',
            },
            type: 'raw_data',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND type.keyword: unrecovered AND metricName.keyword: affected_pods_recovery AND namespace.keyword: openshift-etcd',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Unrecovered etcd container scenario',
    type: 'table',
  },

  getAllPanels():: [
    self.scenarioDetailsRow(),
    self.containerScenarioUuidDetails(),
    self.unrecoveredContainers(),
    self.etcdRecoveryTime(),
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

    // ... (add all other panels in order)
  ],
}
