local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

{

  datasourceVariable(name, label, query, regex='', hide=0):: {
    current: {
      selected: false,
      text: 'Chaos ES - Telemetry',
      value: '${Datasource}',
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
      type: 'grafana-opensearch-datasource',
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

  Datasource:
    var.datasource.new('Datasource', 'prometheus')
    + var.datasource.withRegex('')
    + var.query.generalOptions.withLabel('Datasource')
    + var.query.withRefresh(1)
    + var.query.selectionOptions.withMulti(false)
    + var.query.selectionOptions.withIncludeAll(false),

  namespace:
    var.query.new('namespace', 'label_values(namespace)')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.selectionOptions.withMulti(false)
    + var.query.selectionOptions.withIncludeAll(false)
    + var.query.generalOptions.withLabel('Namespace')
    + var.query.withRefresh(2),

  getAllVariables():: [
    self.Datasource,
    self.namespace,
  ],
}
