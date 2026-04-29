local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

{
  Datasource:
    var.datasource.new('Datasource', 'prometheus')
    + var.datasource.withRegex('')
    + var.query.withRefresh(1)
    + var.query.generalOptions.withLabel('Datasource'),

  namespace:
    var.query.new('namespace')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'namespace',
      'kube_pod_info',
    )
    + var.query.withRefresh(1)
    + var.query.withRegex('')
    + var.query.selectionOptions.withMulti(false)
    + var.query.selectionOptions.withIncludeAll(true)
    + { allValue: '.*' }
    + var.query.generalOptions.withLabel('Namespace'),
}
