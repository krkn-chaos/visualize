local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

local datasource =
  var.datasource.new('Datasource', 'prometheus')
  + var.query.generalOptions.withLabel('Datasource');

local labelVariable(name, label, query, displayName) =
  var.query.new(name)
  + var.query.withDatasourceFromVariable(datasource)
  + var.query.queryTypes.withLabelValues(label, query)
  + var.query.withRefresh(2)
  + var.query.selectionOptions.withMulti(true)
  + var.query.selectionOptions.withIncludeAll(true)
  + var.query.generalOptions.withLabel(displayName);

{
  Datasource: datasource,

  gpu_node: labelVariable(
    'gpu_node',
    'Hostname',
    'DCGM_FI_DEV_GPU_UTIL',
    'GPU Node'
  ),

  gpu:
    var.query.new('gpu')
    + var.query.withDatasourceFromVariable(datasource)
    + var.query.queryTypes.withLabelValues(
      'UUID',
      'DCGM_FI_DEV_GPU_UTIL',
    )
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.generalOptions.withLabel('GPU UUID'),
}
