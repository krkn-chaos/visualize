local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

// All three node variables joined into a single instance regex.
// When Grafana evaluates a multi-value variable it expands to "node1|node2|...".
// "All" expands to ".*", so the union stays correct when any group is unfiltered.
local nodeFilter = '$master_node|$worker_node|$infra_node';

local ts(query, legend) = [
  local p = g.query.prometheus;
  p.new('$' + variables.Datasource.name, query)
  + p.withFormat('time_series')
  + p.withIntervalFactor(2)
  + p.withLegendFormat(legend),
];

local stat(query, legend) = [
  local p = g.query.prometheus;
  p.new('$' + variables.Datasource.name, query)
  + p.withFormat('time_series')
  + p.withInstant(true)
  + p.withLegendFormat(legend),
];

{
  // ── Overview stats ───────────────────────────────────────────────────────────

  totalNodes: {
    query(): stat('count(kube_node_info{})', 'Total'),
  },

  readyNodes: {
    query(): stat('count(kube_node_status_condition{condition="Ready",status="true"})', 'Ready'),
  },

  masterCount: {
    query(): stat('count(kube_node_role{role="master"})', 'Masters'),
  },

  workerCount: {
    query(): stat('count(kube_node_role{role="worker"})', 'Workers'),
  },

  infraCount: {
    query(): stat('count(kube_node_role{role="infra"}) or vector(0)', 'Infra'),
  },

  clusterCpuUtil: {
    query(): stat(
      '(1 - avg(rate(node_cpu_seconds_total{mode="idle",instance=~"' + nodeFilter + '"}[$__rate_interval]))) * 100',
      'CPU %'
    ),
  },

  // ── CPU ─────────────────────────────────────────────────────────────────────

  cpuUsage: {
    query(): ts(
      'sum by (instance) (rate(node_cpu_seconds_total{mode!="idle",instance=~"' + nodeFilter + '"}[$__rate_interval])) * 100',
      '{{instance}}'
    ),
  },

  cpuByMode: {
    query(): ts(
      'sum by (instance, mode) (rate(node_cpu_seconds_total{instance=~"' + nodeFilter + '"}[$__rate_interval])) * 100',
      '{{instance}} - {{mode}}'
    ),
  },

  cpuLoad1: {
    query(): ts(
      'node_load1{instance=~"' + nodeFilter + '"}',
      '{{instance}}'
    ),
  },

  cpuLoad5: {
    query(): ts(
      'node_load5{instance=~"' + nodeFilter + '"}',
      '{{instance}}'
    ),
  },

  cpuIowait: {
    query(): ts(
      'rate(node_cpu_seconds_total{mode="iowait",instance=~"' + nodeFilter + '"}[$__rate_interval]) * 100',
      '{{instance}}'
    ),
  },

  // ── Memory ───────────────────────────────────────────────────────────────────

  memoryUsed: {
    query(): ts(
      'node_memory_MemTotal_bytes{instance=~"' + nodeFilter + '"} - node_memory_MemAvailable_bytes{instance=~"' + nodeFilter + '"}',
      '{{instance}}'
    ),
  },

  memoryAvailable: {
    query(): ts(
      'node_memory_MemAvailable_bytes{instance=~"' + nodeFilter + '"}',
      '{{instance}}'
    ),
  },

  memoryUtilPct: {
    query(): ts(
      '(1 - node_memory_MemAvailable_bytes{instance=~"' + nodeFilter + '"} / node_memory_MemTotal_bytes{instance=~"' + nodeFilter + '"}) * 100',
      '{{instance}}'
    ),
  },

  memoryBreakdown: {
    query(): ts(
      'node_memory_Active_bytes{instance=~"' + nodeFilter + '"}',
      '{{instance}} active'
    ) + ts(
      'node_memory_Cached_bytes{instance=~"' + nodeFilter + '"} + node_memory_Buffers_bytes{instance=~"' + nodeFilter + '"}',
      '{{instance}} cached+buf'
    ) + ts(
      'node_memory_MemFree_bytes{instance=~"' + nodeFilter + '"}',
      '{{instance}} free'
    ),
  },

  // ── Disk I/O ─────────────────────────────────────────────────────────────────

  diskReadThroughput: {
    query(): ts(
      'rate(node_disk_read_bytes_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} read'
    ),
  },

  diskWriteThroughput: {
    query(): ts(
      'rate(node_disk_written_bytes_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} write'
    ),
  },

  diskReadIOPS: {
    query(): ts(
      'rate(node_disk_reads_completed_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} read'
    ),
  },

  diskWriteIOPS: {
    query(): ts(
      'rate(node_disk_writes_completed_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} write'
    ),
  },

  diskReadLatency: {
    query(): ts(
      'rate(node_disk_read_time_seconds_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval])\n/ clamp_min(rate(node_disk_reads_completed_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval]), 1)',
      '{{instance}} - {{device}} read'
    ),
  },

  diskWriteLatency: {
    query(): ts(
      'rate(node_disk_write_time_seconds_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval])\n/ clamp_min(rate(node_disk_writes_completed_total{device=~"$block_device",instance=~"' + nodeFilter + '"}[$__rate_interval]), 1)',
      '{{instance}} - {{device}} write'
    ),
  },

  // ── Network ──────────────────────────────────────────────────────────────────

  networkRxBps: {
    query(): ts(
      'rate(node_network_receive_bytes_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval]) * 8',
      '{{instance}} - {{device}} RX'
    ),
  },

  networkTxBps: {
    query(): ts(
      'rate(node_network_transmit_bytes_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval]) * 8',
      '{{instance}} - {{device}} TX'
    ),
  },

  networkRxPackets: {
    query(): ts(
      'rate(node_network_receive_packets_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} RX'
    ),
  },

  networkTxPackets: {
    query(): ts(
      'rate(node_network_transmit_packets_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} TX'
    ),
  },

  networkErrors: {
    query(): ts(
      'rate(node_network_receive_errs_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} RX err'
    ) + ts(
      'rate(node_network_transmit_errs_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} TX err'
    ),
  },

  networkDrops: {
    query(): ts(
      'rate(node_network_receive_drop_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} RX drop'
    ) + ts(
      'rate(node_network_transmit_drop_total{device=~"$net_device",instance=~"' + nodeFilter + '"}[$__rate_interval])',
      '{{instance}} - {{device}} TX drop'
    ),
  },

  // TCP retransmission rate — best available proxy for network latency/loss
  // without a blackbox / ICMP exporter.
  tcpRetransmitRate: {
    query(): ts(
      'rate(node_netstat_Tcp_RetransSegs{instance=~"' + nodeFilter + '"}[$__rate_interval])\n/ clamp_min(rate(node_netstat_Tcp_OutSegs{instance=~"' + nodeFilter + '"}[$__rate_interval]), 1)',
      '{{instance}}'
    ),
  },

  // Conntrack pressure — high utilisation signals connection-tracking congestion
  conntrackUtilPct: {
    query(): ts(
      'node_nf_conntrack_entries{instance=~"' + nodeFilter + '"} / node_nf_conntrack_entries_limit{instance=~"' + nodeFilter + '"} * 100',
      '{{instance}}'
    ),
  },

  conntrackEntries: {
    query(): ts(
      'node_nf_conntrack_entries{instance=~"' + nodeFilter + '"}',
      '{{instance}} entries'
    ) + ts(
      'node_nf_conntrack_entries_limit{instance=~"' + nodeFilter + '"}',
      '{{instance}} limit'
    ),
  },
}
