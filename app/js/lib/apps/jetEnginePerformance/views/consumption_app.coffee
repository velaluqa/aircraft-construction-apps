ILR.JetEnginePerformance ?= {}
ILR.JetEnginePerformance.Views ?= {}
class ILR.JetEnginePerformance.Views.ConsumptionApp extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]
  legendView: 'ILR.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'
  useHeadup: true
  graphView: 'ILR.Views.InterpolatedGraph'

  graphDefaults:
    xAxisLabel: 'Mach'
