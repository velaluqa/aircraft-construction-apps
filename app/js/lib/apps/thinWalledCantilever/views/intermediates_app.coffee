ILR.ThinWalledCantilever ?= {}
ILR.ThinWalledCantilever.Views ?= {}
class ILR.ThinWalledCantilever.Views.IntermediatesApp extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.ThinWalledCantilever.Views.ParametersAside' }
  ]

  legendView: 'ILR.Views.Legend'
  graphView: 'ILR.Views.InterpolatedGraph'

  graphDefaults:
    xOrigin: null
    yOriginRatio: 0.5
    xOriginRatio: 0.5

  useHeadup: true
