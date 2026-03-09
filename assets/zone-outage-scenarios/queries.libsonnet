{
  zoneOutageScenarioUuidDetails: 'run_uuid.keyword: $run_uuid',
  alertsForUuids: 'run_uuid: $run_uuid',
  zoneRecoveryTime: 'run_uuid.keyword: $run_uuid AND metricName.keyword: zone_outage_recovery',
  affectedNodesCount: 'run_uuid.keyword: $run_uuid AND metricName.keyword: zone_outage_affected_nodes',
}
