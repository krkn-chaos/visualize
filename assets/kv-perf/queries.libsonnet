local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local generateTimeSeriesQuery(query, legend) = [
  local prometheusQuery = g.query.prometheus;
  prometheusQuery.new(
    '$' + variables.Datasource.name,
    query
  )
  + prometheusQuery.withFormat('time_series')
  + prometheusQuery.withIntervalFactor(2)
  + prometheusQuery.withLegendFormat(legend),
];

{
  workersCPU: {
    query():
      generateTimeSeriesQuery('count by (phase) (kubevirt_vmi_phase_count{namespace=~"$namespace"})', '{{phase}}'),
  },
  controlPlanesCPU: {
    query():
      generateTimeSeriesQuery('sum( rate( (node_cpu_seconds_total{ mode != "idle" } * on (instance) group_left label_replace( kube_node_role{ role = "control-plane"} , "instance" , "$1" , "node" ,"(.*)") )[$interval:] ) ) by (instance) * 100', '{{instance}}'),
  },
  workersLoad1: {
    query():
      generateTimeSeriesQuery('count by (namespace) (kubevirt_vmi_info{namespace=~"$namespace"})', '{{namespace}}'),
  },
  controlPlanesLoad1: {
    query():
      generateTimeSeriesQuery('node_load1 * on (instance) group_left label_replace( kube_node_role{ role = "control-plane"} , "instance" , "$1" , "node" ,"(.*)") ', '{{instance}}'),
  },
  workersCGroupCpuRate: {
    query():
      generateTimeSeriesQuery('sum by (id) (( rate(container_cpu_usage_seconds_total{ job=~".*", id =~"/system.slice|/system.slice/kubelet.service|/system.slice/ovs-vswitchd.service|/system.slice/crio.service|/system.slice/systemd-journald.service|/system.slice/ovsdb-server.service|/system.slice/systemd-udevd.service|/kubepods.slice"}[$interval])) * 100 * on (node) group_left kube_node_role{ role = "worker" } )', '{{instance}}'),
  },
}
