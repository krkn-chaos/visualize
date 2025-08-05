local query(expr) = {
  datasource: {
    uid: '$datasource',
  },
  expr: expr,
  instant: true,
  legendFormat: '__auto',
  refId: 'A',
};

{
  cluster: {
    label: 'cluster',
    name: 'cluster',
    query: 'label_values(up{job="kubelet", metrics_path="/metrics/cadvisor"}, cluster)',
    refresh: 2,
    sort: 1,
    type: 'query',
    allValue: '.*',
    datasource: {
      type: 'prometheus',
      uid: '${datasource}',
    },
    hide: 2,
  },
  datasource: {
    name: 'datasource',
    query: 'prometheus',
    type: 'datasource',
    refresh: 1,
    label: 'Data source',
    current: {
      text: 'default',
      value: 'default',
    },
    options: [],
    regex: '',
  },
}
