local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local opensearch = g.query.elasticsearch;

{
  kubeVirtScenarioUuidDetails: 'run_uuid.keyword: $run_uuid',
  alertsForUuids: 'run_uuid: $run_uuid',
  regexRecoveryTime: 'namespace: ".*" AND run_uuid.keyword: $run_uuid AND type: recovered',
  unrecoveredKubeVirtScenario: 'run_uuid.keyword: $run_uuid AND type: unrecovered AND namespace: ".*"',
  etcd99thWalFsyncLatency: 'run_uuid.keyword: $run_uuid AND metricName.keyword: 99thEtcdDiskWalFsync',
  etcd99thRoundTripTime: 'run_uuid.keyword: $run_uuid AND metricName.keyword: cpu-ovnkube-node',
  ovnkubeMasterPodsCpuUsage: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "cpu-ovn-control-plane"',
  ovnMasterPodsMemoryUsage: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "memory-ovn-control-plane"',
  ovnkubePodsCpuUsage: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "cpu-ovnkube-node"',
  apiInflightRequests: 'run_uuid.keyword: $run_uuid AND metricName.keyword: APIInflightRequests',
}
