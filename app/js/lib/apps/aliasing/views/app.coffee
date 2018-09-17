ILR.Aliasing ?= {}
ILR.Aliasing.Views ?= {}
class ILR.Aliasing.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]
  useHeadup: true
  legendView: 'ILR.Aliasing.Views.Legend'
  graphView: 'ILR.Aliasing.Views.Graph'
  graphDefaults:
    xOrigin: null
    xOriginRatio: 0.5
    yOriginRatio: 0.5
