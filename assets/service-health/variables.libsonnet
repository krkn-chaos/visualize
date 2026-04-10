local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

{
  Datasource:
    var.datasource.new('Datasource', 'prometheus')
    + var.query.generalOptions.withLabel('Datasource'),

  namespace:
    var.query.new('namespace')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'namespace',
      'kube_namespace_status_phase{phase="Active"}',
    )
    + var.query.withRefresh(2)
    + var.query.withRegex('')
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.generalOptions.withLabel('Namespace'),
}
