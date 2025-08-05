local grafonnet = import "grafonnet/panel.libsonnet";
local queries = import 'queries.libsonnet';

{
  currentRateBytesReceived: timeseriesPanel(
    'Current Rate of Bytes Received',
    '''sum by (namespace) (
    rate(container_network_receive_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'binBps',
  ),
  currentRateBytesTransmitted: timeseriesPanel(
    'Current Rate of Bytes Transmitted',
    '''sum by (namespace) (
    rate(container_network_transmit_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'binBps',
  ),
  currentStatus: grafonnet.table.new(
    title='Current Status',
    targets=[
      Prometheus(
        expr='''sum by (namespace) (
    rate(container_network_receive_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'A' },
      Prometheus(
        expr='''sum by (namespace) (
    rate(container_network_transmit_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'B' },
      Prometheus(
        expr='''avg by (namespace) (
    rate(container_network_receive_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'C' },
      Prometheus(
        expr='''avg by (namespace) (
    rate(container_network_transmit_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'D' },
      Prometheus(
        expr='''sum by (namespace) (
    rate(container_network_receive_packets_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'E' },
      Prometheus(
        expr='''sum by (namespace) (
    rate(container_network_transmit_packets_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'F' },
      Prometheus(
        expr='''sum by (namespace) (
    rate(container_network_receive_packets_dropped_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'G' },
      Prometheus(
        expr='''sum by (namespace) (
    rate(container_network_transmit_packets_dropped_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
        format='table'
      ) { refId: 'H' },
    ],
    options={
      cellHeight: 'sm',
      footer: {
        countRows: false,
        fields: '',
        reducer: [
          'sum',
        ],
        show: false,
      },
      showHeader: true,
    },
    fieldConfig={
      defaults: {
        custom: {
          align: 'auto',
          cellOptions: {
            type: 'auto',
          },
          inspect: false,
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: 0,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [
        {
          matcher: {
            id: 'byRegexp',
            options: '/Bytes/',
          },
          properties: [
            {
              id: 'unit',
              value: 'binBps',
            },
          ],
        },
        {
          matcher: {
            id: 'byRegexp',
            options: '/Packets/',
          },
          properties: [
            {
              id: 'unit',
              value: 'pps',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Namespace',
          },
          properties: [
            {
              id: 'links',
              value: [
                {
                  title: 'Drill down',
                  url: '/d/8b7a8b326d7a6f1f04244066368c67af/kubernetes-networking-namespace-pods?${datasource:queryparam}&var-cluster=${cluster}&var-namespace=${__data.fields.Namespace}',
                },
              ],
            },
          ],
        },
      ],
    },
    transformations=[
      {
        id: 'joinByField',
        options: {
          byField: 'namespace',
          mode: 'outer',
        },
      },
      {
        id: 'organize',
        options: {
          excludeByName: {
            Time: true,
            'Time 1': true,
            'Time 2': true,
            'Time 3': true,
            'Time 4': true,
            'Time 5': true,
            'Time 6': true,
            'Time 7': true,
            'Time 8': true,
          },
          indexByName: {
            'Time 1': 0,
            'Time 2': 1,
            'Time 3': 2,
            'Time 4': 3,
            'Time 5': 4,
            'Time 6': 5,
            'Time 7': 6,
            'Time 8': 7,
            'Value #A': 9,
            'Value #B': 10,
            'Value #C': 11,
            'Value #D': 12,
            'Value #E': 13,
            'Value #F': 14,
            'Value #G': 15,
            'Value #H': 16,
            namespace: 8,
          },
          renameByName: {
            'Value #A': 'Rx Bytes',
            'Value #B': 'Tx Bytes',
            'Value #C': 'Rx Bytes (Avg)',
            'Value #D': 'Tx Bytes (Avg)',
            'Value #E': 'Rx Packets',
            'Value #F': 'Tx Packets',
            'Value #G': 'Rx Packets Dropped',
            'Value #H': 'Tx Packets Dropped',
            namespace: 'Namespace',
          },
        },
      },
    ],
  ),
  averageRateBytesReceived: timeseriesPanel(
    'Average Rate of Bytes Received',
    '''avg by (namespace) (
    rate(container_network_receive_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'binBps',
  ),
  averageRateBytesTransmitted: timeseriesPanel(
    'Average Rate of Bytes Transmitted',
    '''avg by (namespace) (
    rate(container_network_transmit_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'binBps',
  ),
  receiveBandwidth: timeseriesPanel(
    'Receive Bandwidth',
    '''sum by (namespace) (
    rate(container_network_receive_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'binBps',
  ),
  transmitBandwidth: timeseriesPanel(
    'Transmit Bandwidth',
    '''sum by (namespace) (
    rate(container_network_transmit_bytes_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'binBps',
  ),
  rateReceivedPackets: timeseriesPanel(
    'Rate of Received Packets',
    '''sum by (namespace) (
    rate(container_network_receive_packets_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'pps',
  ),
  rateTransmittedPackets: timeseriesPanel(
    'Rate of Transmitted Packets',
    '''sum by (namespace) (
    rate(container_network_transmit_packets_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'pps',
  ),
  rateReceivedPacketsDropped: timeseriesPanel(
    'Rate of Received Packets Dropped',
    '''sum by (namespace) (
    rate(container_network_receive_packets_dropped_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'pps',
  ),
  rateTransmittedPacketsDropped: timeseriesPanel(
    'Rate of Transmitted Packets Dropped',
    '''sum by (namespace) (
    rate(container_network_transmit_packets_dropped_total{cluster="$cluster",namespace!=""}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'pps',
  ),
  rateTcpRetransmits: timeseriesPanel(
    'Rate of TCP Retransmits out of all sent segments',
    '''sum by (instance) (
    rate(node_netstat_Tcp_RetransSegs{cluster="$cluster"}[$__rate_interval]) / rate(node_netstat_Tcp_OutSegs{cluster="$cluster"}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'percentunit',
  ),
  rateTcpSynRetransmits: timeseriesPanel(
    'Rate of TCP SYN Retransmits out of all retransmits',
    '''sum by (instance) (
    rate(node_netstat_TcpExt_TCPSynRetrans{cluster="$cluster"}[$__rate_interval]) / rate(node_netstat_Tcp_RetransSegs{cluster="$cluster"}[$__rate_interval])
  * on (cluster,namespace,pod) group_left ()
    topk by (cluster,namespace,pod) (
      1,
      max by (cluster,namespace,pod) (kube_pod_info{host_network="false"})
    )
)
''',
    'percentunit',
  ),
}
