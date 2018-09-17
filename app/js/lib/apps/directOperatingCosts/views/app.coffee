ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Views ?= {}
class ILR.DirectOperatingCosts.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'airplanes', view: 'ILR.DirectOperatingCosts.Views.AirplanesAside' }
    { name: 'parameters', view: 'ILR.DirectOperatingCosts.Views.ParametersAside' }
  ]
  legendView: 'ILR.DirectOperatingCosts.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'
  graphView: 'ILR.Views.CurveGraph'
  useHeadup: true
  graphDefaults:
    yPanLocked: true
    yPinchLocked: true
