{
  // Helper function to create a datasource variable
  datasourceVariable(name, label, query, regex='', hide=0):: {
    current: {
      selected: false,
      text: 'Chaos ES - Telemetry',
      value: 'tOFym6UNk',
    },
    hide: hide,
    includeAll: false,
    label: label,
    multi: false,
    name: name,
    options: [],
    query: query,
    queryValue: '',
    refresh: 1,
    regex: regex,
    skipUrlSync: false,
    type: 'datasource',
  },

  // Helper function to create a query variable
  queryVariable(name, label, query, datasourceUid, includeAll=false, multi=false, hide=0, definition='', regex=''):: {
    current: {
      selected: false,
      text: '',
      value: '',
    },
    datasource: {
      type: 'elasticsearch',
      uid: datasourceUid,
    },
    definition: definition,
    hide: hide,
    includeAll: includeAll,
    label: label,
    multi: multi,
    name: name,
    options: [],
    query: query,
    refresh: 1,
    regex: regex,
    skipUrlSync: false,
    sort: 0,
    type: 'query',
  },

  // Get all variables
  getAllVariables():: [
    self.datasourceVariable('Datasource', 'Datasource', 'elasticsearch', '/.*Telemetry*./'),
    self.datasourceVariable('Metrics', 'Metrics', 'elasticsearch', '/.*Metrics*./'),
    self.queryVariable('platform', 'platform', '{"find": "terms", "field": "cloud_infrastructure.keyword"}', '${Datasource}'),
    self.queryVariable('cloud_type', 'cloud_type', '{"find": "terms", "field": "cloud_type.keyword", "query": "cloud_infrastructure.keyword: $platform"}', '${Datasource}'),
    self.queryVariable('networkType', 'networkType', '{"find": "terms", "field": "network_plugins.keyword", "query": "cloud_infrastructure.keyword: $platform AND cloud_type.keyword: $cloud_type"}', '${Datasource}'),
    self.queryVariable('node_count', 'node_count', '{"find": "terms", "field": "node_summary_infos.count",  "query": "cloud_infrastructure.keyword: $platform AND scenarios.scenario: /tmp/pod_scenario.yaml AND cloud_type.keyword: $cloud_type"}', 'tOFym6UNk'),
    self.queryVariable('major_version', 'major_version', '{"find": "terms", "field": "major_version.keyword",  "query": "cloud_infrastructure.keyword: $platform AND network_plugins.keyword: $networkType AND scenarios.scenario: /tmp/pod_scenario.yaml AND cloud_type.keyword: $cloud_type" }', 'tOFym6UNk', true, true),
    self.queryVariable('run_uuid', 'run_uuid', '{"find": "terms", "field": "run_uuid.keyword", "query": "cloud_infrastructure.keyword: $platform AND network_plugins.keyword: $networkType AND scenarios.scenario: /tmp/pod_scenario.yaml AND major_version.keyword: $major_version AND cloud_type.keyword: $cloud_type AND node_summary_infos.count: $node_count"}', '${Datasource}', true, true),
  ],
}
