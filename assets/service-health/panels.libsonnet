local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  stat: {
    local stat = g.panel.stat,
    local options = stat.options,

    base(title, unit, targets, gridPos):
      stat.new(title)
      + stat.datasource.withType('prometheus')
      + stat.datasource.withUid('$Datasource')
      + stat.standardOptions.withUnit(unit)
      + stat.queryOptions.withTargets(targets)
      + stat.gridPos.withX(gridPos.x)
      + stat.gridPos.withY(gridPos.y)
      + stat.gridPos.withH(gridPos.h)
      + stat.gridPos.withW(gridPos.w)
      + options.withJustifyMode('auto')
      + options.withGraphMode('area')
      + options.text.withTitleSize(12)
      + options.reduceOptions.withCalcs(['lastNotNull'])
      + options.withColorMode('background'),

    // Green when value > 0, grey at 0
    healthy(title, targets, gridPos):
      self.base(title, 'none', targets, gridPos)
      + stat.standardOptions.color.withMode('thresholds')
      + stat.standardOptions.thresholds.withMode('absolute')
      + stat.standardOptions.thresholds.withSteps([
        { color: 'text', value: null },
        { color: 'green', value: 1 },
      ]),

    // Grey at 0 (good), red when > 0 (bad)
    unhealthy(title, targets, gridPos):
      self.base(title, 'none', targets, gridPos)
      + stat.standardOptions.color.withMode('thresholds')
      + stat.standardOptions.thresholds.withMode('absolute')
      + stat.standardOptions.thresholds.withSteps([
        { color: 'green', value: null },
        { color: 'red', value: 1 },
      ]),
  },

  table: {
    local table = g.panel.table,
    local options = table.options,
    local override = table.standardOptions.override,

    base(title, targets, gridPos):
      table.new(title)
      + table.datasource.withType('prometheus')
      + table.datasource.withUid('$Datasource')
      + table.queryOptions.withTargets(targets)
      + table.queryOptions.withTransformations([
        { id: 'merge', options: {} },
        {
          id: 'organize',
          options: {
            excludeByName: { Time: true, '__name__': true, job: true, instance: true },
            renameByName: {},
          },
        },
      ])
      + table.gridPos.withX(gridPos.x)
      + table.gridPos.withY(gridPos.y)
      + table.gridPos.withH(gridPos.h)
      + table.gridPos.withW(gridPos.w)
      + options.withSortBy([{ desc: true, displayName: 'available' }]),

    serviceStatus(title, targets, gridPos):
      self.base(title, targets, gridPos)
      + table.standardOptions.withOverrides([
        // Color "available" column: grey=0, green>=1
        override.byName.new('available')
        + override.byName.withProperty('custom.displayMode', 'color-background')
        + override.byName.withProperty('thresholds', {
          mode: 'absolute',
          steps: [
            { color: 'red', value: null },
            { color: 'green', value: 1 },
          ],
        }),
        // Color "not_ready" column: green=0, red>=1
        override.byName.new('not_ready')
        + override.byName.withProperty('custom.displayMode', 'color-background')
        + override.byName.withProperty('thresholds', {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 1 },
          ],
        }),
      ]),

    podStatus(title, targets, gridPos):
      self.base(title, targets, gridPos)
      + table.standardOptions.withOverrides([
        override.byName.new('ready')
        + override.byName.withProperty('custom.displayMode', 'color-background')
        + override.byName.withProperty('thresholds', {
          mode: 'absolute',
          steps: [
            { color: 'red', value: null },
            { color: 'green', value: 1 },
          ],
        }),
      ]),

    serviceInfo(title, targets, gridPos):
      self.base(title, targets, gridPos)
      + table.queryOptions.withTransformations([
        { id: 'merge', options: {} },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true, '__name__': true, job: true, instance: true,
              container: true, endpoint: true, pod: true, uid: true, Value: true,
            },
            renameByName: { type: 'service_type', cluster_ip: 'cluster_ip' },
          },
        },
        { id: 'sortBy', options: { fields: [{ desc: false, displayName: 'namespace' }] } },
      ])
      + table.standardOptions.withOverrides([
        override.byName.new('service_type')
        + override.byName.withProperty('custom.displayMode', 'color-background')
        + override.byName.withProperty('mappings', [
          {
            type: 'value',
            options: {
              ClusterIP: { color: 'blue', index: 0, text: 'ClusterIP' },
              NodePort: { color: 'orange', index: 1, text: 'NodePort' },
              LoadBalancer: { color: 'green', index: 2, text: 'LoadBalancer' },
              ExternalName: { color: 'purple', index: 3, text: 'ExternalName' },
            },
          },
        ]),
      ]),

    routeStatus(title, targets, gridPos):
      self.base(title, targets, gridPos)
      + table.queryOptions.withTransformations([
        { id: 'merge', options: {} },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true, '__name__': true, job: true, instance: true,
              container: true, endpoint: true, pod: true, service: true,
              status: true, Value: true,
            },
            renameByName: { type: 'admission_status' },
          },
        },
        { id: 'sortBy', options: { fields: [{ desc: false, displayName: 'namespace' }] } },
      ])
      + table.standardOptions.withOverrides([
        override.byName.new('admission_status')
        + override.byName.withProperty('custom.displayMode', 'color-background')
        + override.byName.withProperty('mappings', [
          {
            type: 'value',
            options: {
              Admitted: { color: 'green', index: 0, text: 'Admitted' },
              Accepted: { color: 'yellow', index: 1, text: 'Accepted' },
              Rejected: { color: 'red', index: 2, text: 'Rejected' },
            },
          },
        ]),
      ]),

    deploymentStatus(title, targets, gridPos):
      self.base(title, targets, gridPos)
      + table.standardOptions.withOverrides([
        override.byName.new('unavailable')
        + override.byName.withProperty('custom.displayMode', 'color-background')
        + override.byName.withProperty('thresholds', {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 1 },
          ],
        }),
        override.byName.new('available')
        + override.byName.withProperty('custom.displayMode', 'color-background')
        + override.byName.withProperty('thresholds', {
          mode: 'absolute',
          steps: [
            { color: 'red', value: null },
            { color: 'green', value: 1 },
          ],
        }),
      ]),
  },

  timeSeries: {
    local timeSeries = g.panel.timeSeries,
    local custom = timeSeries.fieldConfig.defaults.custom,
    local options = timeSeries.options,

    base(title, unit, targets, gridPos):
      timeSeries.new(title)
      + timeSeries.queryOptions.withTargets(targets)
      + timeSeries.datasource.withType('prometheus')
      + timeSeries.datasource.withUid('$Datasource')
      + timeSeries.standardOptions.withUnit(unit)
      + timeSeries.gridPos.withX(gridPos.x)
      + timeSeries.gridPos.withY(gridPos.y)
      + timeSeries.gridPos.withH(gridPos.h)
      + timeSeries.gridPos.withW(gridPos.w)
      + custom.withDrawStyle('line')
      + custom.withLineInterpolation('linear')
      + custom.withBarAlignment(0)
      + custom.withLineWidth(2)
      + custom.withFillOpacity(8)
      + custom.withGradientMode('none')
      + custom.withSpanNulls(true)
      + custom.withShowPoints('never')
      + custom.stacking.withMode('none')
      + options.tooltip.withMode('multi')
      + options.tooltip.withSort('desc')
      + options.legend.withShowLegend(true)
      + options.legend.withDisplayMode('table')
      + options.legend.withPlacement('bottom')
      + options.legend.withCalcs(['mean', 'max', 'last']),
  },
}
