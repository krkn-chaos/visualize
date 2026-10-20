local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local gpu = 'UUID=~"$gpu",Hostname=~"$gpu_node"';

local ts(query, legend) = [
  local p = g.query.prometheus;
  p.new('$' + 'Datasource', query)
  + p.withFormat('time_series')
  + p.withIntervalFactor(2)
  + p.withLegendFormat(legend),
];

local stat(query, legend) = [
  local p = g.query.prometheus;
  p.new('$' + 'Datasource', query)
  + p.withFormat('time_series')
  + p.withInstant(true)
  + p.withLegendFormat(legend),
];

{
  gpuCount: {
    query(): stat('sum(kube_node_status_capacity{resource="nvidia_com_gpu",node=~"$gpu_node"}) or vector(0)', 'GPUs'),
  },
  gpuNodeCount: {
    query(): stat('count(kube_node_status_capacity{resource="nvidia_com_gpu",node=~"$gpu_node"} > 0) or vector(0)', 'GPU Nodes'),
  },
  dcgmGpuCount: {
    query(): stat('count(count by (UUID) (DCGM_FI_DEV_GPU_UTIL{' + gpu + '})) or vector(0)', 'DCGM GPUs'),
  },
  averageUtilization: {
    query(): stat('avg(DCGM_FI_DEV_GPU_UTIL{' + gpu + '})', 'Utilisation'),
  },
  gpuCapacityByNode: {
    query(): ts(
      'kube_node_status_capacity{resource="nvidia_com_gpu",node=~"$gpu_node"}',
      '{{node}}'
    ),
  },
  utilization: {
    query(): ts('DCGM_FI_DEV_GPU_UTIL{' + gpu + '}', '{{Hostname}} / {{UUID}}'),
  },
  memoryUsed: {
    // DCGM exporter reports FB_USED and FB_FREE in MiB.
    query(): ts('DCGM_FI_DEV_FB_USED{' + gpu + '}', '{{Hostname}} / {{UUID}}'),
  },
  memoryUtilization: {
    query(): ts(
      '100 * DCGM_FI_DEV_FB_USED{' + gpu + '} / clamp_min(DCGM_FI_DEV_FB_USED{' + gpu + '} + DCGM_FI_DEV_FB_FREE{' + gpu + '}, 1)',
      '{{Hostname}} / {{UUID}}'
    ),
  },
  power: {
    query(): ts('DCGM_FI_DEV_POWER_USAGE{' + gpu + '}', '{{Hostname}} / {{UUID}}'),
  },
  temperature: {
    query(): ts('DCGM_FI_DEV_GPU_TEMP{' + gpu + '}', '{{Hostname}} / {{UUID}}'),
  },
  smClock: {
    query(): ts('DCGM_FI_DEV_SM_CLOCK{' + gpu + '}', '{{Hostname}} / {{UUID}}'),
  },
}
