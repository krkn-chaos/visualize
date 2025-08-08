local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local elasticsearch = g.query.elasticsearch;

{
  appScenarioUuidDetails: 'run_uuid.keyword: $run_uuid',
  alertsForUuids: 'run_uuid: $run_uuid',
  openshiftMonitoringRecoveryTime: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.config.namespace_pattern: "openshift-monitoring"',
  openshiftRegexRecoveryTime: 'scenarios.parameters.config.namespace_pattern: "openshift-.*" AND run_uuid.keyword: $run_uuid',
  openshiftOvnRecoveryTime: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.config.namespace_pattern: "openshift-ovn-kubernetes"',
  openshiftEtcdRecoveryTime: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.config.namespace_pattern: "openshift-etcd"',
  unrecoveredOvnPodScenario: 'run_uuid.keyword: $run_uuid AND scenarios.affected_pods.unrecovered.namespace: openshift-ovn-kuberenetes',
  etcd99thWalFsyncLatency: 'run_uuid.keyword: $run_uuid AND metricName.keyword: 99thEtcdDiskWalFsync',
  etcd99thRoundTripTime: 'run_uuid.keyword: $run_uuid AND metricName.keyword: cpu-ovnkube-node',
  ovnkubeMasterPodsCpuUsage: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "cpu-ovn-control-plane"',
  ovnMasterPodsMemoryUsage: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "memory-ovn-control-plane"',
  ovnkubePodsCpuUsage: 'run_uuid.keyword: $run_uuid AND metricName.keyword: "cpu-ovnkube-node"',
  apiInflightRequests: 'run_uuid.keyword: $run_uuid AND metricName.keyword: APIInflightRequests',
}
