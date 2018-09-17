ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Views ?= {}
class ILR.AirplaneInternalLoads.Views.WingApp extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.AirplaneInternalLoads.Views.WingParametersAside' }
  ]
  legendView: 'ILR.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'
  graphView: 'ILR.Views.InterpolatedGraph'
  useHeadup: true
  graphDefaults:
    yScale: 1.65
    yOriginRatio: 0.25
