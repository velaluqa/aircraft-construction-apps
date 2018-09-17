ILR.CabinSlendernessRatio ?= {}
ILR.CabinSlendernessRatio.Views ?= {}
class ILR.CabinSlendernessRatio.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.CabinSlendernessRatio.Views.ParametersAside' }
  ]
  legendView: 'ILR.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'
  useHeadup: true
  graphView: 'ILR.CabinSlendernessRatio.Views.Graph'

  graphDefaults:
    yAxisLabel: 'W/L'
    xAxisLabel: 'PAX-Capacity'
    yOffset: -0.05
