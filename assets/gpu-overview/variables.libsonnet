local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

local gpuNodes = 'kube_node_labels{label_nvidia_com_gpu_deploy_dcgm_exporter="true"';
local selectedRegion = ',label_topology_kubernetes_io_region=~"$region"';
local selectedZone = ',label_topology_kubernetes_io_zone=~"$zone"';
local selectedPool = ',label_run_ai_simulated_gpu_node_pool=~"$gpu_node_pool"';
local selectedType = ',label_node_kubernetes_io_instance_type=~"$instance_type"';
local datasource =
  var.datasource.new('Datasource', 'prometheus')
  + var.query.generalOptions.withLabel('Datasource');

local labelVariable(name, label, selector, displayName) =
  var.query.new(name)
  + var.query.withDatasourceFromVariable(datasource)
  + var.query.queryTypes.withLabelValues(label, selector + '}')
  + var.query.withRefresh(2)
  + var.query.selectionOptions.withMulti(true)
  + var.query.selectionOptions.withIncludeAll(true)
  + var.query.generalOptions.withLabel(displayName);

{
  Datasource: datasource,

  region: labelVariable('region', 'label_topology_kubernetes_io_region', gpuNodes, 'Region'),

  zone: labelVariable(
    'zone',
    'label_topology_kubernetes_io_zone',
    gpuNodes + selectedRegion,
    'Availability Zone'
  ),

  gpu_node_pool: labelVariable(
    'gpu_node_pool',
    'label_run_ai_simulated_gpu_node_pool',
    gpuNodes + selectedRegion + selectedZone,
    'GPU Node Pool'
  ),

  instance_type: labelVariable(
    'instance_type',
    'label_node_kubernetes_io_instance_type',
    gpuNodes + selectedRegion + selectedZone + selectedPool,
    'Instance Type'
  ),

  gpu_node: labelVariable(
    'gpu_node',
    'node',
    gpuNodes + selectedRegion + selectedZone + selectedPool + selectedType,
    'GPU Node'
  ),

  gpu:
    var.query.new('gpu')
    + var.query.withDatasourceFromVariable(datasource)
    + var.query.queryTypes.withLabelValues(
      'UUID',
      'DCGM_FI_DEV_GPU_UTIL{Hostname=~"$gpu_node"}',
    )
    + var.query.withRefresh(2)
    + var.query.selectionOptions.withMulti(true)
    + var.query.selectionOptions.withIncludeAll(true)
    + var.query.generalOptions.withLabel('GPU UUID'),
}
