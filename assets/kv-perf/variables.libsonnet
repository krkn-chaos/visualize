local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

{
  Datasource:
    var.datasource.new('Datasource', 'prometheus')
    + var.query.generalOptions.withLabel('Datasource'),

  worker_node:
    var.query.new('_worker_node')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'node',
      'kube_node_role{role=~"worker"}',
    )
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti()
    + var.query.selectionOptions.withIncludeAll(false)
    + var.query.generalOptions.withLabel('Worker'),

  namespace:
    var.query.new('namespace')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'namespace',
      'kube_pod_info{namespace!="(cluster-density.*|node-density-.*)"}',
    )
    + var.query.withRefresh(2)
    + var.query.withRegex('')
    + var.query.selectionOptions.withMulti(false)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.generalOptions.withLabel('Namespace'),

  interval:
    var.interval.new('interval', ['2m', '3m', '4m', '5m'],)
    + var.interval.generalOptions.withLabel('interval'),
}
