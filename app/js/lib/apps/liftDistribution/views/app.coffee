ILR.LiftDistribution ?= {}
ILR.LiftDistribution.Views ?= {}
class ILR.LiftDistribution.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]

  legendView: 'ILR.Views.Legend'
  graphView: 'ILR.Views.InterpolatedGraph'
  rangeHandlerView: 'ILR.Views.LegendHandler'

  graphDefaults:
    yScale: 1.65
    yOriginRatio: 0.3
    xAxisLabel: 'eta'
    yAxisLabel: ''


  useHeadup: true
