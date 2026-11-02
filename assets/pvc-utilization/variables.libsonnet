local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

local datasource =
  var.datasource.new('Datasource', 'prometheus')
  + var.query.generalOptions.withLabel('Datasource');

local allSelected = {
  current: {
    selected: true,
    text: ['All'],
    value: ['$__all'],
  },
};

local labelValues(metric, label) =
  local expression = 'label_values(' + metric + ', ' + label + ')';
  {
    definition: expression,
    query: {
      qryType: 1,
      query: expression,
      refId: 'PrometheusVariableQueryEditor-VariableQuery',
    },
  };

{
  Datasource: datasource,

  namespace:
    var.query.new('namespace')
    + var.query.withDatasourceFromVariable(datasource)
    + labelValues('kube_pod_info', 'namespace')
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + allSelected
    + var.query.generalOptions.withLabel('Namespace'),

  pvc:
    var.query.new('pvc')
    + var.query.withDatasourceFromVariable(datasource)
    + labelValues(
      'kube_persistentvolumeclaim_resource_requests_storage_bytes{namespace=~"$namespace"}',
      'persistentvolumeclaim'
    )
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + allSelected
    + var.query.generalOptions.withLabel('PVC'),

  vmi:
    var.query.new('vmi')
    + var.query.withDatasourceFromVariable(datasource)
    + labelValues(
      'kubevirt_vmi_filesystem_used_bytes{namespace=~"$namespace"}',
      'name'
    )
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + allSelected
    + var.query.generalOptions.withLabel('VMI'),

  mountPoint:
    var.query.new('mount_point')
    + var.query.withDatasourceFromVariable(datasource)
    + labelValues(
      'kubevirt_vmi_filesystem_used_bytes{namespace=~"$namespace",name=~"$vmi"}',
      'mount_point'
    )
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + allSelected
    + var.query.generalOptions.withLabel('Guest Mount Point'),
}
