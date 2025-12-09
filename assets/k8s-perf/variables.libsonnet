local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

{
  Datasource:
    var.datasource.new('Datasource', 'prometheus')
    + var.datasource.withRegex('')
    + var.query.withRefresh(1)
    + var.query.selectionOptions.withIncludeAll(false)
    + var.query.selectionOptions.withMulti(false),

  _worker_node:
    var.query.new('_worker_node')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'node',
      'kube_node_role{role=~"worker"}',
    )
    + var.query.generalOptions.withLabel('Worker')
    + var.query.withSort(0)
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withIncludeAll(false)
    + var.query.selectionOptions.withMulti(true),

  namespace:
    var.query.new('namespace')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'namespace'
    )
    + var.query.generalOptions.withLabel('Namespace')
    + var.query.withSort(0)
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.selectionOptions.withMulti(false),

  block_device:
    var.query.new('block_device')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'device',
      'node_disk_written_bytes_total',
    )
    + var.query.generalOptions.withLabel('Block device')
    + var.query.withSort(0)
    + var.query.withRegex('/^(?:(?!dm|rb).)*$/')
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.selectionOptions.withMulti(true),

  net_device:
    var.query.new('net_device')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'device',
      'node_network_receive_bytes_total',
    )
    + var.query.generalOptions.withLabel('Network device')
    + var.query.withSort(0)
    + var.query.withRegex('/^((br|en|et).*)$/')
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.selectionOptions.withMulti(true),

  interval:
    var.interval.new('interval', ['2m', '3m', '4m', '5m'])
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.interval.generalOptions.withLabel('interval')
    + var.interval.withAutoOption(count=30, minInterval='10s')
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(false)
    + var.query.selectionOptions.withIncludeAll(false),
}
