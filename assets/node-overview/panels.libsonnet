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
      + options.reduceOptions.withCalcs(['lastNotNull'])
      + stat.standardOptions.color.withMode('thresholds')
      + options.withColorMode('value'),

    node(title, unit, targets, gridPos):
      self.base(title, unit, targets, gridPos),

    utilPercent(title, targets, gridPos):
      self.base(title, 'percent', targets, gridPos)
      + stat.standardOptions.withMin(0)
      + stat.standardOptions.withMax(100)
      + stat.standardOptions.color.withMode('thresholds')
      + stat.standardOptions.thresholds.withMode('absolute')
      + stat.standardOptions.thresholds.withSteps([
        { color: 'green', value: null },
        { color: 'yellow', value: 70 },
        { color: 'red', value: 90 },
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
      + options.tooltip.withSort('desc'),

    withLegend(title, unit, targets, gridPos):
      self.base(title, unit, targets, gridPos)
      + options.legend.withShowLegend(true)
      + options.legend.withDisplayMode('table')
      + options.legend.withPlacement('bottom')
      + options.legend.withCalcs(['mean', 'max', 'min']),

    withLegendRight(title, unit, targets, gridPos):
      self.base(title, unit, targets, gridPos)
      + options.legend.withShowLegend(true)
      + options.legend.withDisplayMode('table')
      + options.legend.withPlacement('right')
      + options.legend.withCalcs(['mean', 'max', 'min']),
  },
}
