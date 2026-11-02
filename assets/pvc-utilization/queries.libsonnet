local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local pvcFilter = 'namespace=~"$namespace",persistentvolumeclaim=~"$pvc"';
local vmiFilesystemFilter = 'namespace=~"$namespace",name=~"$vmi",mount_point=~"$mount_point"';

local ts(query, legend) = [
  local p = g.query.prometheus;
  p.new('$Datasource', query)
  + p.withFormat('time_series')
  + p.withIntervalFactor(2)
  + p.withLegendFormat(legend),
];

local stat(query, legend) = [
  local p = g.query.prometheus;
  p.new('$Datasource', query)
  + p.withFormat('time_series')
  + p.withInstant(true)
  + p.withLegendFormat(legend),
];

// kubelet_volume_stats_* can be reported by more than one kubelet when a claim
// is mounted by multiple pods. Collapse to one series per claim before totaling.
local claimSum(metric) = 'sum(max by (namespace, persistentvolumeclaim) (' + metric + '{' + pvcFilter + '}))';
local guestFilesystemMax(metric) = 'max by (namespace, name, disk_name, mount_point, file_system_type) (' + metric + '{' + vmiFilesystemFilter + '})';

{
  pvcCount: {
    query(): stat(
      'count(count by (namespace, persistentvolumeclaim) (kube_persistentvolumeclaim_resource_requests_storage_bytes{' + pvcFilter + '})) or vector(0)',
      'PVCs'
    ),
  },

  totalRequestedCapacity: {
    query(): stat(
      'sum(max by (namespace, persistentvolumeclaim) (kube_persistentvolumeclaim_resource_requests_storage_bytes{' + pvcFilter + '}))',
      'Requested'
    ),
  },

  totalUsed: {
    query(): stat(claimSum('kubelet_volume_stats_used_bytes'), 'Used'),
  },

  totalCapacity: {
    query(): stat(claimSum('kubelet_volume_stats_capacity_bytes'), 'Capacity'),
  },

  clusterUtilization: {
    query(): stat(
      '100 * ' + claimSum('kubelet_volume_stats_used_bytes') + ' / clamp_min(' + claimSum('kubelet_volume_stats_capacity_bytes') + ', 1)',
      'Utilization'
    ),
  },

  utilizationByPvc: {
    query(): ts(
      '100 * max by (namespace, persistentvolumeclaim) (kubelet_volume_stats_used_bytes{' + pvcFilter + '}) / clamp_min(max by (namespace, persistentvolumeclaim) (kubelet_volume_stats_capacity_bytes{' + pvcFilter + '}), 1)',
      '{{namespace}} / {{persistentvolumeclaim}}'
    ),
  },

  usedByPvc: {
    query(): ts(
      'max by (namespace, persistentvolumeclaim) (kubelet_volume_stats_used_bytes{' + pvcFilter + '})',
      '{{namespace}} / {{persistentvolumeclaim}}'
    ),
  },

  availableByPvc: {
    query(): ts(
      'max by (namespace, persistentvolumeclaim) (kubelet_volume_stats_available_bytes{' + pvcFilter + '})',
      '{{namespace}} / {{persistentvolumeclaim}}'
    ),
  },

  requestedCapacityByPvc: {
    query(): ts(
      'max by (namespace, persistentvolumeclaim) (kube_persistentvolumeclaim_resource_requests_storage_bytes{' + pvcFilter + '})',
      '{{namespace}} / {{persistentvolumeclaim}}'
    ),
  },

  guestFilesystemUtilizationByVmi: {
    query(): ts(
      '100 * ' + guestFilesystemMax('kubevirt_vmi_filesystem_used_bytes') + ' / clamp_min(' + guestFilesystemMax('kubevirt_vmi_filesystem_capacity_bytes') + ', 1)',
      '{{namespace}} / {{name}} / {{mount_point}}'
    ),
  },

  guestFilesystemUsedByVmi: {
    query(): ts(
      guestFilesystemMax('kubevirt_vmi_filesystem_used_bytes'),
      '{{namespace}} / {{name}} / {{mount_point}}'
    ),
  },

  guestFilesystemCapacityByVmi: {
    query(): ts(
      guestFilesystemMax('kubevirt_vmi_filesystem_capacity_bytes'),
      '{{namespace}} / {{name}} / {{mount_point}}'
    ),
  },
}
