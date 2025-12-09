local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

{
  Datasource:
    var.datasource.new('Datasource', 'prometheus')
    + var.datasource.withRegex('')
    + var.query.withRefresh(1)
    + var.query.selectionOptions.withIncludeAll(false)
    + var.query.selectionOptions.withMulti(false),

  namespace:
    var.query.new('namespace')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'namespace',
      'kube_namespace_status_phase',
    )
    + var.query.generalOptions.withLabel('Namespace')
    + var.query.withSort(0)
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.selectionOptions.withMulti(false),

  vmi:
    var.query.new('vmi')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'name',
      'kubevirt_vmi_info{namespace=~"$namespace"}',
    )
    + var.query.generalOptions.withLabel('Virtual Machine Instance')
    + var.query.withSort(0)
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.selectionOptions.withMulti(true),

  interval:
    var.interval.new('interval', ['1m', '2m', '5m', '10m'])
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.interval.generalOptions.withLabel('Interval')
    + var.interval.withAutoOption(count=30, minInterval='10s')
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(false)
    + var.query.selectionOptions.withIncludeAll(false),
}
