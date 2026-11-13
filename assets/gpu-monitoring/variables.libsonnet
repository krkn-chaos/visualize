// GPU Monitoring Dashboard Variables
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  Datasource:
    g.dashboard.variable.datasource.new('datasource', 'prometheus')
    + g.dashboard.variable.datasource.withCurrent('Prometheus')
    + g.dashboard.variable.datasource.withRegex('(?!grafana).*prometheus.*'),

  namespace:
    g.dashboard.variable.query.new('namespace', 'label_values(kube_pod_info, namespace)')
    + g.dashboard.variable.query.withCurrent('mokka')
    + g.dashboard.variable.query.withMulti(true)
    + g.dashboard.variable.query.withIncludeAll(true),

  pod:
    g.dashboard.variable.query.new('pod', 'label_values(kube_pod_info{namespace="$namespace"}, pod)')
    + g.dashboard.variable.query.withMulti(true)
    + g.dashboard.variable.query.withIncludeAll(true),

  gpu_index:
    g.dashboard.variable.query.new('gpu_index', 'label_values(nvidia_smi_gpu_memory_used_mb, gpu_index)')
    + g.dashboard.variable.query.withMulti(true)
    + g.dashboard.variable.query.withIncludeAll(true),
}
