local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  stat(title, unit, targets, pos):
    g.panel.stat.new(title)
    + g.panel.stat.datasource.withType('prometheus')
    + g.panel.stat.datasource.withUid('$Datasource')
    + g.panel.stat.standardOptions.withUnit(unit)
    + g.panel.stat.queryOptions.withTargets(targets)
    + g.panel.stat.gridPos.withX(pos.x)
    + g.panel.stat.gridPos.withY(pos.y)
    + g.panel.stat.gridPos.withH(pos.h)
    + g.panel.stat.gridPos.withW(pos.w)
    + g.panel.stat.options.withGraphMode('none')
    + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

  timeSeries(title, unit, targets, pos):
    local panel = g.panel.timeSeries;
    panel.new(title)
    + panel.queryOptions.withTargets(targets)
    + panel.datasource.withType('prometheus')
    + panel.datasource.withUid('$Datasource')
    + panel.standardOptions.withUnit(unit)
    + panel.gridPos.withX(pos.x)
    + panel.gridPos.withY(pos.y)
    + panel.gridPos.withH(pos.h)
    + panel.gridPos.withW(pos.w)
    + panel.fieldConfig.defaults.custom.withDrawStyle('line')
    + panel.fieldConfig.defaults.custom.withLineWidth(2)
    + panel.fieldConfig.defaults.custom.withFillOpacity(8)
    + panel.options.tooltip.withMode('multi')
    + panel.options.legend.withShowLegend(true)
    + panel.options.legend.withDisplayMode('table')
    + panel.options.legend.withPlacement('bottom')
    + panel.options.legend.withCalcs(['mean', 'max']),
}
