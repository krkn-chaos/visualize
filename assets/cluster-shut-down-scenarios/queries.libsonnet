{
  clusterShutDownScenarioUuidDetails: 'run_uuid.keyword: $run_uuid',
  alertsForUuids: 'run_uuid: $run_uuid',
  clusterRecoveryTime: 'run_uuid.keyword: $run_uuid AND metricName.keyword: cluster_shut_down_recovery',
  nodeRecoveryTime: 'run_uuid.keyword: $run_uuid AND metricName.keyword: affected_nodes_recovery',
}
