// GPU Monitoring Dashboard Variables
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

{
  Datasource:
    var.datasource.new('datasource', 'prometheus')
    + var.datasource.withRegex('')
    + var.query.withRefresh(1)
    + var.query.generalOptions.withLabel('Datasource'),

  // Node (hostname) variable - from the dcgm-exporter `hostname` label
  node:
    var.query.new('node')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'hostname',
      'DCGM_FI_DEV_GPU_UTIL',
    )
    + var.query.withRefresh(1)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + { allValue: '.*' }
    + var.query.generalOptions.withLabel('Node'),

  // Namespace variable - namespaces with GPU workloads.
  // NOTE: must use exported_namespace because cluster monitoring scrapes
  // dcgm-exporter with honorLabels: false (the plain namespace label is
  // the exporter's own namespace, nvidia-gpu-operator).
  namespace:
    var.query.new('namespace')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'exported_namespace',
      'DCGM_FI_DEV_GPU_UTIL{hostname=~"$node"}',
    )
    + var.query.withRefresh(1)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + { allValue: '.*' }
    + var.query.generalOptions.withLabel('Namespace'),

  // Pod variable - pods currently holding a GPU, filtered by the
  // selected namespace. Only pods appearing in DCGM metrics are listed,
  // i.e. pods with a GPU actually assigned.
  pod:
    var.query.new('pod')
    + var.query.withDatasourceFromVariable(self.Datasource)
    + var.query.queryTypes.withLabelValues(
      'exported_pod',
      'DCGM_FI_DEV_GPU_UTIL{exported_namespace=~"$namespace"}',
    )
    + var.query.withRefresh(1)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + { allValue: '.*' }
    + var.query.generalOptions.withLabel('Pod'),
}
