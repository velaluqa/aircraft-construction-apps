ILR.InternationalStandardAtmosphere ?= {}
ILR.InternationalStandardAtmosphere.Views ?= {}
class ILR.InternationalStandardAtmosphere.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
    { name: 'calculator', view: 'ILR.InternationalStandardAtmosphere.Views.CalculatorAside' }
  ]
  legendView: 'ILR.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'

  valueAtRangeAxis: 'y'
  valueAtRangeAttribute: 'altitude'
  valueAtRangePrecision: 0

  useHeadup: true
  graphView: 'ILR.InternationalStandardAtmosphere.Views.Graph'

  graphDefaults:
    yOrigin: 30
    xOrigin: 0
