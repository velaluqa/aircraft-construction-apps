ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Views ?= {}
class ILR.BeamSectionProperties.Views.HalfCircleApp extends ILR.Views.BaseApp
  asideViews: [
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]
  legendView: null
  rangeHandlerView: null
  useHeadup: true
  graphView: 'ILR.BeamSectionProperties.Views.HalfCircleGraph'

  graphDefaults:
    xOrigin: null
    xOriginRatio: 0.5
    yOriginRatio: 0.5
    scaleLink: 'x'
