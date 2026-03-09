{
  networkChaosScenarioUuidDetails: 'run_uuid.keyword: $run_uuid',
  alertsForUuids: 'run_uuid: $run_uuid',
  networkLatency: 'run_uuid.keyword: $run_uuid AND metricName.keyword: network_chaos_latency',
  packetLoss: 'run_uuid.keyword: $run_uuid AND metricName.keyword: network_chaos_packet_loss',
  networkBandwidth: 'run_uuid.keyword: $run_uuid AND metricName.keyword: network_chaos_bandwidth',
}
