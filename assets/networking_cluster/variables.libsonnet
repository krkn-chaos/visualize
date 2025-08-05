local grafana = import "grafana.libsonnet";

{
  datasource: grafana.datasource.new(
    name='datasource',
    query='prometheus',
    options=[],
    refresh=1,
    regex='',
    current={
      text: 'default',
      value: 'default',
    },
  ),
  cluster: grafana.query.new(
    name='cluster',
    query='label_values(up{job="kubelet", metrics_path="/metrics/cadvisor"}, cluster)',
    refresh=2,
    allValue='.*',
    hide=2,
    datasource={
      type: 'prometheus',
      uid: '${datasource}',
    },
    sort=1,
  ),
}
