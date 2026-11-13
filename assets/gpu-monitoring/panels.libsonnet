// GPU Monitoring Grafana Panels
//
// All panels are driven by query objects from queries.libsonnet, i.e.
// objects exposing `query()` and `legendFormat`. A panel accepts either a
// single query object or a list of them (multiple targets on one panel).
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  timeSeries: {
    local timeSeries = g.panel.timeSeries,
    local options = timeSeries.options,

    // Normalize a query argument into a list of query objects
    local asList(query) = if std.type(query) == 'array' then query else [query],

    // Build a prometheus target from a query object
    local target(q) =
      g.query.prometheus.new('$datasource', q.query())
      + g.query.prometheus.withLegendFormat(q.legendFormat),

    // Generic GPU time series panel.
    //   title:   panel title
    //   query:   query object or list of query objects
    //   gridPos: {x, y, w, h}
    //   unit:    Grafana unit id (defaults to 'short')
    gpuTimeSeries(title, query, gridPos, unit='short')::
      timeSeries.new(title)
      + timeSeries.datasource.withType('prometheus')
      + timeSeries.datasource.withUid('$datasource')
      + timeSeries.standardOptions.withUnit(unit)
      + timeSeries.queryOptions.withTargets([target(q) for q in asList(query)])
      + timeSeries.gridPos.withX(gridPos.x)
      + timeSeries.gridPos.withY(gridPos.y)
      + timeSeries.gridPos.withH(gridPos.h)
      + timeSeries.gridPos.withW(gridPos.w)
      + options.legend.withDisplayMode('table')
      + options.legend.withPlacement('right'),
  },

  stat: {
    local stat = g.panel.stat,
    local options = stat.options,

    // Normalize a query argument into a list of query objects
    local asList(query) = if std.type(query) == 'array' then query else [query],

    // Generic GPU stat panel.
    //   query:   query object or list of query objects
    //   unit:    Grafana unit id (defaults to 'short')
    gpuStatPanel(title, query, gridPos, unit='short')::
      stat.new(title)
      + stat.datasource.withType('prometheus')
      + stat.datasource.withUid('$datasource')
      + stat.standardOptions.withUnit(unit)
      + stat.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', q.query())
        + g.query.prometheus.withInstant(true)
        + g.query.prometheus.withLegendFormat(q.legendFormat)
        for q in asList(query)
      ])
      + stat.gridPos.withX(gridPos.x)
      + stat.gridPos.withY(gridPos.y)
      + stat.gridPos.withH(gridPos.h)
      + stat.gridPos.withW(gridPos.w)
      + options.withGraphMode('none')
      + options.withColorMode('value'),
  },

  table: {
    local table = g.panel.table,

    // Normalize a query argument into a list of query objects
    local asList(query) = if std.type(query) == 'array' then query else [query],

    // Generic GPU table panel.
    gpuTablePanel(title, query, gridPos)::
      table.new(title)
      + table.datasource.withType('prometheus')
      + table.datasource.withUid('$datasource')
      + table.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', q.query())
        + g.query.prometheus.withFormat('table')
        + g.query.prometheus.withInstant(true)
        + g.query.prometheus.withLegendFormat(q.legendFormat)
        for q in asList(query)
      ])
      + table.gridPos.withX(gridPos.x)
      + table.gridPos.withY(gridPos.y)
      + table.gridPos.withH(gridPos.h)
      + table.gridPos.withW(gridPos.w),
  },
}
