ILR.VnDiagram ?= {}
ILR.VnDiagram.Views ?= {}
class ILR.VnDiagram.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]
  legendView: 'ILR.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'
  graphView: 'ILR.VnDiagram.Views.Graph'
  useHeadup: true
  graphDefaults:
    yOriginRatio: 0.3
    yScale: 1
    yAxisLabelLocale: 'graph.yAxisLabel'
    xAxisLabelLocale: 'graph.xAxisLabel'
