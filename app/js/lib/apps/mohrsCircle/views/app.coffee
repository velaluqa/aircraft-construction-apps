ILR.MohrsCircle ?= {}
ILR.MohrsCircle.Views ?= {}
class ILR.MohrsCircle.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'parameters', view: 'ILR.Views.GroupedParametersAside' }
  ]

  graphView: 'ILR.MohrsCircle.Views.Graph'
  legendView: null
  rangeHandlerView: null

  graphDefaults:
    xOrigin: null
    yOrigin: null
    xOriginRatio: 0.5
    yOriginRatio: 0.5
    scaleLink: 'x'
    xAxisLabel: 'nx, n1'
    yAxisLabel: 'ny, n2'

  useHeadup: true
