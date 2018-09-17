ILR.ThinWalledCantilever ?= {}
ILR.ThinWalledCantilever.Views ?= {}
class ILR.ThinWalledCantilever.Views.BeamApp extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.ThinWalledCantilever.Views.ParametersAside' }
  ]

  legendView: 'ILR.Views.Legend'
  graphView: 'ILR.Views.InterpolatedGraph'

  graphDefaults:
    yOriginRatio: 0.7
    xOriginRatio: 0.1
    scaleLink: 'y'

  useHeadup: true
