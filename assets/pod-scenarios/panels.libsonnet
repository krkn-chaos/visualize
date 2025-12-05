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

  podScenarioUuidDetails():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
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
        datasource: { type: 'grafana-opensearch-datasource', uid: '${Datasource}' },
        metrics: [
          { id: '1', settings: { size: '500' }, type: 'raw_data' },
        ],
        query: queries.podScenarioUuidDetails,
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Pod Scenario UUID Details',
    type: 'table',
  },


  monitoringRecoveryTime():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
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
      overrides: [
        {
          __systemRef: 'hideSeriesFrom',
          matcher: {
            id: 'byNames',
            options: {
              mode: 'exclude',
              names: [
                '4.19.0-0.nightly-2025-06-24-180820 54019b34-d2f8-49ca-aca8-f991b8e2afc7',
              ],
              prefix: 'All except:',
              readOnly: true,
            },
          },
          properties: [
            {
              id: 'custom.hideFrom',
              value: {
                legend: false,
                tooltip: false,
                viz: true,
              },
            },
          ],
        },
      ],
    },
    gridPos: {
      h: 8,
      w: 12,
      x: 0,
      y: 19,
    },
    id: 1,
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
            id: '6',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'run_uuid.keyword',
            id: '7',
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
          type: 'grafana-opensearch-datasource',
          uid: '${Datasource}',
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
        query: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.config.namespace_pattern: "openshift-monitoring"',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Openshift Monitoring Recovery Time',
    type: 'timeseries',
  },

  regexRecoveryTime():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
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
      w: 12,
      x: 12,
      y: 19,
    },
    id: 7,
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
            field: 'run_uuid.keyword',
            id: '2',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '20',
            },
            type: 'terms',
          },
          {
            field: 'cluster_version.keyword',
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
          type: 'grafana-opensearch-datasource',
          uid: '${Datasource}',
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
        query: 'scenarios.parameters.config.namespace_pattern: "openshift-.*" AND run_uuid.keyword: $run_uuid',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Openshift Regex Recovery Time',
    type: 'timeseries',
  },

  ovnRecoveryTime():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
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
      w: 12,
      x: 0,
      y: 27,
    },
    id: 4,
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
            field: 'run_uuid.keyword',
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
            field: 'cluster_version.keyword',
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
          type: 'grafana-opensearch-datasource',
          uid: '${Datasource}',
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
        query: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.config.namespace_pattern: "openshift-ovn-kubernetes"',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Openshift OVN Recovery Time',
    type: 'timeseries',
  },

  etcdRecoveryTime():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
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
      w: 12,
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
          type: 'grafana-opensearch-datasource',
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
        query: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.config.namespace_pattern: "openshift-etcd"',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Openshift ETCD Recovery Time',
    type: 'timeseries',
  },

  unrecoveredPods():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Datasource}',
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
          type: 'grafana-opensearch-datasource',
          uid: 'bc8a9e77-4816-4004-a752-7ac41f90e3a3',
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
        query: 'run_uuid.keyword: $run_uuid AND scenarios.affected_pods.unrecovered.namespace: openshift-ovn-kuberenetes',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Unrecovered ovn pod scenario',
    type: 'table',
  },

  etcd99thWalFsyncLatency():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    description: '',
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
          ],
        },
        unit: 's',
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 11,
      x: 0,
      y: 44,
    },
    id: 11,
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
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '1',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '4',
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
        hide: false,
        metrics: [
          {
            '$$hashKey': 'object:31',
            field: 'value',
            id: '1',
            meta: {},
            settings: {},
            type: 'avg',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: 99thEtcdDiskWalFsync',
        refId: 'B',
        timeField: 'timestamp',
      },
    ],
    title: 'Etcd 99th WAL fsync latency ',
    type: 'timeseries',
  },

  etcd99thRoundTripTime():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    description: '',
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
          ],
        },
        unit: 's',
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 10,
      x: 11,
      y: 44,
    },
    id: 14,
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
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '1',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '4',
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
        hide: false,
        metrics: [
          {
            '$$hashKey': 'object:31',
            field: 'value',
            id: '1',
            meta: {},
            settings: {},
            type: 'avg',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: 99thEtcdRoundTripTime',
        refId: 'B',
        timeField: 'timestamp',
      },
    ],
    title: 'Etcd 99th Round Trip Time',
    type: 'timeseries',
  },

  ovnMasterCPU():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    fieldConfig: {
      defaults: {
        color: {
          mode: 'thresholds',
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
        unit: 'percent',
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 9,
      x: 0,
      y: 52,
    },
    id: 9,
    options: {
      displayMode: 'gradient',
      maxVizHeight: 300,
      minVizHeight: 16,
      minVizWidth: 8,
      namePlacement: 'auto',
      orientation: 'auto',
      reduceOptions: {
        calcs: [
          'lastNotNull',
        ],
        fields: '',
        values: false,
      },
      showUnfilled: true,
      sizing: 'auto',
      valueMode: 'color',
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '',
        bucketAggs: [
          {
            field: 'run_uuid.keyword',
            id: '5',
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
            id: '6',
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
        hide: false,
        metrics: [
          {
            field: 'value',
            id: '1',
            meta: {
              avg: true,
              std_deviation_bounds_lower: false,
              std_deviation_bounds_upper: false,
            },
            settings: {
              script: '_value',
            },
            type: 'extended_stats',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "cpu-ovn-control-plane"',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'ovnkube-master pods CPU usage',
    type: 'bargauge',
  },

  ovnMasterMemUsage():: {
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
          axisBorderShow: false,
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'bars',
          fillOpacity: 100,
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
          ],
        },
        unit: 'µs',
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 9,
      x: 9,
      y: 52,
    },
    id: 12,
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
            field: 'run_uuid.keyword',
            id: '5',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'container.keyword',
            id: '6',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '7',
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
        hide: false,
        metrics: [
          {
            field: 'value',
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
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "memory-ovn-control-plane"',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'ovn master pods Memory usage',
    type: 'timeseries',
  },

  ovnCPUUsage():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    description: '',
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
          drawStyle: 'bars',
          fillOpacity: 100,
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
          ],
        },
        unit: 'µs',
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 9,
      x: 0,
      y: 60,
    },
    id: 13,
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
            field: 'run_uuid.keyword',
            id: '5',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'container.keyword',
            id: '6',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '_term',
              size: '20',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '7',
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
        hide: false,
        metrics: [
          {
            field: 'value',
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
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "cpu-ovnkube-node"',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'ovnkube pods CPU usage',
    type: 'timeseries',
  },

  apiInflightRequests():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    description: '',
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
          ],
        },
        unit: 'none',
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 10,
      x: 11,
      y: 60,
    },
    id: 15,
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
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '1',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '4',
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
        hide: false,
        metrics: [
          {
            '$$hashKey': 'object:31',
            field: 'value',
            id: '1',
            meta: {},
            settings: {},
            type: 'avg',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: APIInflightRequests',
        refId: 'B',
        timeField: 'timestamp',
      },
    ],
    title: 'APIInflightRequests',
    type: 'timeseries',
  },
  maxMemoryKubelet():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    description: "Max memory usage from all worker's kubelet",
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
        unit: 'bytes',  // Set unit to bytes
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 12,
      x: 12,
      y: 70,  // Adjust y position
    },
    id: 17,  // Assign a unique ID
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
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '1',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '4',
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
        hide: false,
        metrics: [
          {
            field: 'value',
            id: '1',
            meta: {},
            settings: {},
            type: 'avg',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: max-memory-kubelet',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Kubelet Max Memory Usage (Workers)',
    type: 'timeseries',
  },
  cpuKubelet():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    description: "Average CPU usage from all worker's kubelet",
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
        unit: 'percent',  // Set unit to percent
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 12,
      x: 0,
      y: 70,  // Adjust y position to avoid overlap
    },
    id: 16,  // Assign a unique ID
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
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '1',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '4',
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
        hide: false,
        metrics: [
          {
            field: 'value',
            id: '1',
            meta: {},
            settings: {},
            type: 'avg',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: cpu-kubelet',
        refId: 'A',
        timeField: 'timestamp',
      },
    ],
    title: 'Kubelet Average CPU Usage (Workers)',
    type: 'timeseries',
  },
  mastersMemoryUsageGauge():: {
    datasource: {
      type: 'grafana-opensearch-datasource',
      uid: '${Metrics}',
    },
    description: 'Average memory usage of master nodes compared to their maximum observed usage for the selected period (max-memory-masters).',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'thresholds',
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
              color: 'orange',
              value: 70,  // 70% of maxValue
            },
            {
              color: 'red',
              value: 90,  // 90% of maxValue
            },
          ],
        },
        unit: 'bytes',  // Set unit to bytes for memory
      },
      overrides: [],
    },
    gridPos: {
      h: 8,
      w: 8,
      x: 0,  // Adjust x, y, h, w to fit your dashboard layout
      y: 80,  // Adjust y position to avoid overlap
    },
    id: 18,  // Assign a unique ID, increment from your last one
    options: {
      displayMode: 'lcd',  // Can be 'lcd', 'gradient', 'basic'
      maxValue: 68719476736,  // Example: 64 GB in bytes (64 * 1024^3). Adjust to your typical master node memory.
      namePlacement: 'auto',
      orientation: 'auto',
      reduceOptions: {
        calcs: [
          'lastNotNull',  // Display the last non-null value
        ],
        fields: '',
        values: false,
      },
      showUnfilled: true,
      sizing: 'auto',
      valueMode: 'color',  // 'color', 'text', 'value'
    },
    pluginVersion: '10.4.0',
    targets: [
      {
        alias: '',
        bucketAggs: [
          {
            field: 'run_uuid.keyword',
            id: '3',
            settings: {
              min_doc_count: '1',
              order: 'desc',
              orderBy: '1',
              size: '0',
            },
            type: 'terms',
          },
          {
            field: 'timestamp',
            id: '4',
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
        hide: false,
        metrics: [
          {
            field: 'value',
            id: '1',
            meta: {},
            settings: {},
            type: 'avg',
          },
        ],
        query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: memory-masters',  // Targetting the 'memory-masters' metric
        refId: 'A',
        timeField: 'timestamp',
      },
      // You could theoretically add a second target for max-memory-masters if you were using
      // transformations to compute a ratio or dynamically set max value, but for a simple gauge,
      // it primarily displays one metric against a configured max.
      // {
      //   alias: 'Max Observed',
      //   bucketAggs: [
      //     { field: 'run_uuid.keyword', id: '3', settings: { min_doc_count: '1', order: 'desc', orderBy: '1', size: '0' }, type: 'terms' },
      //     { field: 'timestamp', id: '4', settings: { interval: 'auto', min_doc_count: '0', timeZone: 'utc', trimEdges: '0' }, type: 'date_histogram' },
      //   ],
      //   datasource: { type: 'elasticsearch', uid: '${Metrics}' },
      //   hide: true, // Hide this series as it's for context/calculation, not direct display as gauge value
      //   metrics: [
      //     { field: 'value', id: '1', meta: {}, settings: {}, type: 'avg' },
      //   ],
      //   query: 'run_uuid.keyword: $run_uuid AND metricName.keyword: max-memory-masters', // The max-memory-masters metric
      //   refId: 'B',
      //   timeField: 'timestamp',
      // },
    ],
    title: 'Master Node Memory Usage',
    type: 'gauge',
  },

  getAllPanels():: [
    self.scenarioDetailsRow(),
    self.podScenarioUuidDetails(),
    self.regexRecoveryTime(),
    self.unrecoveredPods(),
    self.monitoringRecoveryTime(),
    self.ovnRecoveryTime(),
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
