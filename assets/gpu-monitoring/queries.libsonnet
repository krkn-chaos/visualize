// GPU Monitoring Prometheus Queries
{
  gpuMemoryUsed: {
    query():: 'nvidia_smi_gpu_memory_used_mb',
    legendFormat: 'GPU {{ gpu_index }} Memory Used',
  },

  gpuMemoryFree: {
    query():: 'nvidia_smi_gpu_memory_free_mb',
    legendFormat: 'GPU {{ gpu_index }} Memory Free',
  },

  gpuMemoryTotal: {
    query():: 'nvidia_smi_gpu_memory_total_mb',
    legendFormat: 'GPU {{ gpu_index }} Total Memory',
  },

  gpuUtilization: {
    query():: 'nvidia_smi_gpu_utilization_percent',
    legendFormat: 'GPU {{ gpu_index }} Utilization',
  },

  gpuTemperature: {
    query():: 'nvidia_smi_temperature_gpu',
    legendFormat: 'GPU {{ gpu_index }} Temperature',
  },

  gpuPowerUsage: {
    query():: 'nvidia_smi_power_draw_watts',
    legendFormat: 'GPU {{ gpu_index }} Power',
  },

  gpuMemoryUtilizationPercent: {
    query():: '(nvidia_smi_gpu_memory_used_mb / nvidia_smi_gpu_memory_total_mb) * 100',
    legendFormat: 'GPU {{ gpu_index }} Utilization %',
  },

  gpuCountAllocated: {
    query():: 'count(kube_pod_container_resource_limits{resource="nvidia_com_gpu"})',
    legendFormat: 'GPUs Allocated',
  },

  gpuCountByPod: {
    query():: 'count(kube_pod_container_resource_limits{resource="nvidia_com_gpu"}) by (pod, namespace)',
    legendFormat: '{{ pod }} ({{ namespace }})',
  },

  gpuMemoryByPod: {
    query():: 'nvidia_smi_gpu_memory_used_mb',
    legendFormat: 'Pod GPU {{ pod }}',
  },

  gpuMemoryTrend: {
    query():: 'rate(nvidia_smi_gpu_memory_used_mb[5m])',
    legendFormat: 'GPU {{ gpu_index }} Memory Change Rate',
  },

  gpuUtilizationAverage: {
    query():: 'avg(nvidia_smi_gpu_utilization_percent)',
    legendFormat: 'Average GPU Utilization',
  },

  gpuTemperatureMax: {
    query():: 'max(nvidia_smi_temperature_gpu)',
    legendFormat: 'Max GPU Temperature',
  },

  gpuIdleTime: {
    query():: 'count(nvidia_smi_gpu_utilization_percent{nvidia_smi_gpu_utilization_percent < 10})',
    legendFormat: 'Idle GPUs',
  },

  podGpuAllocation: {
    query():: 'kube_pod_container_resource_limits{resource="nvidia_com_gpu"}',
    legendFormat: '{{ pod }} - {{ container }}',
  },

  gpuMemoryPressure: {
    query():: 'nvidia_smi_gpu_memory_used_mb > (nvidia_smi_gpu_memory_total_mb * 0.85)',
    legendFormat: 'GPU {{ gpu_index }} High Memory',
  },

  gpuErrors: {
    query():: 'nvidia_smi_error_count',
    legendFormat: 'GPU {{ gpu_index }} Errors',
  },
}
