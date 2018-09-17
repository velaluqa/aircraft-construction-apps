ILR.Buckling ?= {}
ILR.Buckling.Views ?= {}
class ILR.Buckling.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]
  legendView: 'ILR.Views.Legend'
  useHeadup: true
  graphView: 'ILR.Buckling.Views.Graph'

  graphDefaults:
    yAxisLabel: 'k'
    xAxisLabel: 'aspect ratio'
    yOrigin: 30
    yLabelPosition: 'none'
    xLabelPosition: 'none'
