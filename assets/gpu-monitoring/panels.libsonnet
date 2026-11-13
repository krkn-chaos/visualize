// GPU Monitoring Grafana Panels
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  timeSeries: {
    gpuMemoryTimeSeries(title, query, gridPos)::
      g.panel.timeSeries.new(title)
      + g.panel.timeSeries.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query)
        + g.query.prometheus.withLegendFormat('GPU {{ gpu_index }}'),
      ])
      + g.panel.timeSeries.options.withShowLegend(true)
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.fieldConfig.defaults.custom.hideFrom.withLegend(false)
      + g.panel.timeSeries.fieldConfig.defaults.unit.short()
      + g.panel.withGridPos(gridPos),

    gpuUtilizationTimeSeries(title, query, gridPos)::
      g.panel.timeSeries.new(title)
      + g.panel.timeSeries.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query)
        + g.query.prometheus.withLegendFormat('GPU {{ gpu_index }}'),
      ])
      + g.panel.timeSeries.options.withShowLegend(true)
      + g.panel.timeSeries.fieldConfig.defaults.unit.percent()
      + g.panel.timeSeries.fieldConfig.defaults.min(0)
      + g.panel.timeSeries.fieldConfig.defaults.max(100)
      + g.panel.timeSeries.fieldConfig.defaults.thresholds.mode.absolute()
      + g.panel.timeSeries.fieldConfig.defaults.thresholds.steps([
        { color: 'green', value: null },
        { color: 'yellow', value: 50 },
        { color: 'red', value: 85 },
      ])
      + g.panel.withGridPos(gridPos),

    gpuTemperatureTimeSeries(title, query, gridPos)::
      g.panel.timeSeries.new(title)
      + g.panel.timeSeries.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query)
        + g.query.prometheus.withLegendFormat('GPU {{ gpu_index }}'),
      ])
      + g.panel.timeSeries.fieldConfig.defaults.unit.celsius()
      + g.panel.timeSeries.fieldConfig.defaults.thresholds.steps([
        { color: 'blue', value: null },
        { color: 'green', value: 30 },
        { color: 'yellow', value: 60 },
        { color: 'orange', value: 80 },
        { color: 'red', value: 90 },
      ])
      + g.panel.withGridPos(gridPos),
  },

  stat: {
    gpuCountStatPanel(title, query, gridPos)::
      g.panel.stat.new(title)
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query),
      ])
      + g.panel.stat.options.withColorMode('background')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.fieldConfig.defaults.unit.short()
      + g.panel.withGridPos(gridPos),

    gpuUtilizationStat(title, query, gridPos)::
      g.panel.stat.new(title)
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query),
      ])
      + g.panel.stat.fieldConfig.defaults.unit.percent()
      + g.panel.stat.fieldConfig.defaults.min(0)
      + g.panel.stat.fieldConfig.defaults.max(100)
      + g.panel.stat.fieldConfig.defaults.thresholds.steps([
        { color: 'green', value: null },
        { color: 'yellow', value: 50 },
        { color: 'red', value: 85 },
      ])
      + g.panel.withGridPos(gridPos),

    gpuTemperatureStat(title, query, gridPos)::
      g.panel.stat.new(title)
      + g.panel.stat.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query),
      ])
      + g.panel.stat.fieldConfig.defaults.unit.celsius()
      + g.panel.stat.fieldConfig.defaults.thresholds.steps([
        { color: 'blue', value: null },
        { color: 'green', value: 30 },
        { color: 'yellow', value: 60 },
        { color: 'orange', value: 80 },
        { color: 'red', value: 90 },
      ])
      + g.panel.withGridPos(gridPos),
  },

  table: {
    gpuAllocationTable(title, query, gridPos)::
      g.panel.table.new(title)
      + g.panel.table.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query),
      ])
      + g.panel.table.options.withShowHeader(true)
      + g.panel.table.options.withSortBy([{ name: 'pod', desc: false }])
      + g.panel.withGridPos(gridPos),
  },

  gauge: {
    gpuMemoryGauge(title, query, gridPos)::
      g.panel.gauge.new(title)
      + g.panel.gauge.queryOptions.withTargets([
        g.query.prometheus.new('$datasource', query),
      ])
      + g.panel.gauge.options.withShowThresholdLabels(false)
      + g.panel.gauge.options.withShowThresholdMarkers(true)
      + g.panel.gauge.fieldConfig.defaults.unit.percent()
      + g.panel.gauge.fieldConfig.defaults.min(0)
      + g.panel.gauge.fieldConfig.defaults.max(100)
      + g.panel.gauge.fieldConfig.defaults.thresholds.steps([
        { color: 'green', value: null },
        { color: 'yellow', value: 70 },
        { color: 'red', value: 90 },
      ])
      + g.panel.withGridPos(gridPos),
  },
}
