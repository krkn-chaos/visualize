// GPU Monitoring Prometheus Queries
//
// Metrics are exposed by the NVIDIA GPU Operator's dcgm-exporter
// (DCGM_FI_* metrics). Per-pod attribution comes from the pod, namespace
// and container labels dcgm-exporter adds when a GPU is assigned to a
// Kubernetes pod.
//
// NOTE: OpenShift cluster monitoring scrapes dcgm-exporter with
// honorLabels: false, so dcgm's pod/namespace/container labels are
// renamed to exported_pod/exported_namespace/exported_container (the
// plain pod/namespace/container labels belong to the exporter pod
// itself). Per-pod queries therefore use the exported_* labels.
//
// Filters: $node (hostname) scopes device-level panels, $namespace and
// $pod scope the workload panels. There is deliberately no gpu index
// variable: every node in this cluster has a single GPU (index 0), so
// hostname alone identifies a GPU.
{
  // Frame buffer (device memory) usage in MiB
  gpuMemoryUsed: {
    query():: 'DCGM_FI_DEV_FB_USED{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} ({{ modelName }})',
  },

  gpuMemoryFree: {
    query():: 'DCGM_FI_DEV_FB_FREE{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} ({{ modelName }})',
  },

  // dcgm-exporter does not expose total FB memory directly, derive it
  gpuMemoryUtilizationPercent: {
    query():: '100 * DCGM_FI_DEV_FB_USED{hostname=~"$node"} / (DCGM_FI_DEV_FB_USED{hostname=~"$node"} + DCGM_FI_DEV_FB_FREE{hostname=~"$node"} + DCGM_FI_DEV_FB_RESERVED{hostname=~"$node"})',
    legendFormat: '{{ hostname }} GPU {{ gpu }}',
  },

  // MiB per second trend of frame buffer usage
  gpuMemoryTrend: {
    query():: 'deriv(DCGM_FI_DEV_FB_USED{hostname=~"$node"}[5m])',
    legendFormat: '{{ hostname }} GPU {{ gpu }}',
  },

  gpuUtilization: {
    query():: 'DCGM_FI_DEV_GPU_UTIL{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} ({{ modelName }})',
  },

  gpuUtilizationByPod: {
    query():: 'DCGM_FI_DEV_GPU_UTIL{exported_pod!="", exported_namespace=~"$namespace", exported_pod=~"$pod", hostname=~"$node"}',
    legendFormat: '{{ exported_namespace }}/{{ exported_pod }}',
  },

  gpuTemperature: {
    query():: 'DCGM_FI_DEV_GPU_TEMP{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }}',
  },

  gpuPowerUsage: {
    query():: 'DCGM_FI_DEV_POWER_USAGE{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }}',
  },

  gpuSmClock: {
    query():: 'DCGM_FI_DEV_SM_CLOCK{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} SM',
  },

  gpuMemClock: {
    query():: 'DCGM_FI_DEV_MEM_CLOCK{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} Memory',
  },

  gpuPcieRx: {
    query():: 'DCGM_FI_PROF_PCIE_RX_BYTES{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} RX',
  },

  gpuPcieTx: {
    query():: 'DCGM_FI_PROF_PCIE_TX_BYTES{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} TX',
  },

  // Tensor pipe activity is a 0-1 ratio, scale to percent
  gpuTensorActive: {
    query():: '100 * DCGM_FI_PROF_PIPE_TENSOR_ACTIVE{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }}',
  },

  // Number of distinct GPUs currently reporting metrics
  gpuCountDetected: {
    query():: 'count(count by (hostname, gpu) (DCGM_FI_DEV_GPU_UTIL{hostname=~"$node"}))',
    legendFormat: 'GPUs Detected',
  },

  // Number of GPUs requested by pods on the selected node, scoped by namespace
  gpuCountAllocated: {
    query():: 'sum(kube_pod_container_resource_limits{resource="nvidia_com_gpu", namespace=~"$namespace"} and on (namespace, pod) kube_pod_info{node=~"$node"}) or vector(0)',
    legendFormat: 'GPUs Allocated',
  },

  gpuCountByPod: {
    query():: 'sum(kube_pod_container_resource_limits{resource="nvidia_com_gpu", namespace=~"$namespace", pod=~"$pod"} and on (namespace, pod) kube_pod_info{node=~"$node"}) by (namespace, pod)',
    legendFormat: '{{ namespace }}/{{ pod }}',
  },

  podGpuAllocation: {
    query():: 'kube_pod_container_resource_limits{resource="nvidia_com_gpu", namespace=~"$namespace", pod=~"$pod"}',
    legendFormat: '{{ namespace }}/{{ pod }} - {{ container }}',
  },

  // Frame buffer usage for GPUs currently assigned to a pod
  gpuMemoryByPod: {
    query():: 'DCGM_FI_DEV_FB_USED{exported_pod!="", exported_namespace=~"$namespace", exported_pod=~"$pod", hostname=~"$node"}',
    legendFormat: '{{ exported_namespace }}/{{ exported_pod }}',
  },

  gpuUtilizationAverage: {
    query():: 'avg(DCGM_FI_DEV_GPU_UTIL{hostname=~"$node"})',
    legendFormat: 'Average GPU Utilization',
  },

  gpuTemperatureMax: {
    query():: 'max(DCGM_FI_DEV_GPU_TEMP{hostname=~"$node"})',
    legendFormat: 'Max GPU Temperature',
  },

  gpuIdleTime: {
    query():: 'count(DCGM_FI_DEV_GPU_UTIL{hostname=~"$node"} < 10) or vector(0)',
    legendFormat: 'Idle GPUs',
  },

  gpuMemoryPressure: {
    query():: '(DCGM_FI_DEV_FB_USED{hostname=~"$node"} / (DCGM_FI_DEV_FB_USED{hostname=~"$node"} + DCGM_FI_DEV_FB_FREE{hostname=~"$node"} + DCGM_FI_DEV_FB_RESERVED{hostname=~"$node"})) > 0.85',
    legendFormat: '{{ hostname }} GPU {{ gpu }} High Memory',
  },

  gpuErrors: {
    query():: 'DCGM_FI_DEV_UNCORRECTABLE_REMAPPED_ROWS{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} Uncorrectable',
  },

  gpuCorrectableErrors: {
    query():: 'DCGM_FI_DEV_CORRECTABLE_REMAPPED_ROWS{hostname=~"$node"}',
    legendFormat: '{{ hostname }} GPU {{ gpu }} Correctable',
  },
}
