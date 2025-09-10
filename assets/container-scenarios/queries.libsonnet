local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local elasticsearch = g.query.elasticsearch;

{
  containerScenarioUuidDetails: 'run_uuid.keyword: $run_uuid',
  alertsForUuids: 'run_uuid: $run_uuid',
  openshiftEtcdRecoveryTime: 'run_uuid.keyword: $run_uuid AND scenarios.parameters.config.namespace_pattern: "openshift-etcd"',

}
