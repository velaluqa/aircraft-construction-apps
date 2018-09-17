ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Views ?= {}
class ILR.AirplaneInternalLoads.Views.FuselageApp extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]
  legendView: 'ILR.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'
  graphView: 'ILR.Views.InterpolatedGraph'
  useHeadup: true
  graphDefaults:
    yOriginRatio: 0.65
    yScale: 1.8
