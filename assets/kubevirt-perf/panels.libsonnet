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
      + options.withGraphMode('none')
      + options.text.withTitleSize(12)
      + stat.standardOptions.color.withMode('thresholds')
      + options.withColorMode('value'),

    genericStatPanel(title, unit, targets, gridPos):
      self.base(title, unit, targets, gridPos)
      + stat.options.reduceOptions.withCalcs([
        'lastNotNull',
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
      + custom.withLineWidth(1)
      + custom.withFillOpacity(10)
      + custom.withGradientMode('none')
      + custom.withSpanNulls(false)
      + custom.withShowPoints('never')
      + custom.stacking.withMode('none')
      + options.tooltip.withMode('multi')
      + options.tooltip.withSort('desc'),

    genericTimeSeriesPanel(title, unit, targets, gridPos):
      self.base(title, unit, targets, gridPos)
      + options.legend.withShowLegend(false)
      + options.legend.withDisplayMode('list')
      + options.legend.withPlacement('bottom'),

    genericTimeSeriesLegendPanel(title, unit, targets, gridPos):
      self.base(title, unit, targets, gridPos)
      + options.legend.withShowLegend(true)
      + options.legend.withDisplayMode('table')
      + options.legend.withPlacement('right')
      + options.legend.withCalcs([
        'mean',
        'max',
        'min',
      ]),

    genericTimeSeriesListLegend(title, unit, targets, gridPos):
      self.base(title, unit, targets, gridPos)
      + options.legend.withShowLegend(true)
      + options.legend.withDisplayMode('list')
      + options.legend.withPlacement('bottom'),

    vmiPhaseTimeline(title, targets, gridPos):
      self.base(title, 'none', targets, gridPos)
      + custom.withSpanNulls(true)
      + options.legend.withShowLegend(true)
      + options.legend.withDisplayMode('list')
      + options.legend.withPlacement('right')
      + (local ts = g.panel.timeSeries; ts.standardOptions.withMin(0))
      + (local ts = g.panel.timeSeries; ts.standardOptions.withMax(5))
      + (local ts = g.panel.timeSeries; ts.standardOptions.withMappings([
        {
          type: 'value',
          options: {
            '0': { text: 'Failed', color: 'red', index: 0 },
            '1': { text: 'Pending', color: 'yellow', index: 1 },
            '2': { text: 'Scheduling', color: 'orange', index: 2 },
            '3': { text: 'Scheduled', color: 'light-green', index: 3 },
            '4': { text: 'Running', color: 'green', index: 4 },
            '5': { text: 'Succeeded', color: 'blue', index: 5 },
          },
        },
      ])),
  },

  table: {
    local table = g.panel.table,
    local options = table.options,

    base(title, targets, gridPos):
      table.new(title)
      + table.datasource.withType('prometheus')
      + table.datasource.withUid('$Datasource')
      + table.queryOptions.withTargets(targets)
      + table.gridPos.withX(gridPos.x)
      + table.gridPos.withY(gridPos.y)
      + table.gridPos.withH(gridPos.h)
      + table.gridPos.withW(gridPos.w),

    genericTablePanel(title, targets, gridPos):
      self.base(title, targets, gridPos)
      + table.standardOptions.withOverrides([
        {
          matcher: { id: 'byName', options: 'Time' },
          properties: [{ id: 'custom.hidden', value: true }],
        },
        {
          matcher: { id: 'byName', options: 'Value' },
          properties: [{ id: 'custom.hidden', value: true }],
        },
      ]),
  },
}
