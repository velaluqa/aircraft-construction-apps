ILR.SandwichStructuredComposite ?= {}
ILR.SandwichStructuredComposite.Views ?= {}
class ILR.SandwichStructuredComposite.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'curves', view: 'ILR.Views.CurvesAside' }
    { name: 'parameters', view: 'ILR.Views.GroupedParametersAside' }
  ]
  legendView: 'ILR.SandwichStructuredComposite.Views.Legend'
  rangeHandlerView: 'ILR.Views.LegendHandler'
  useHeadup: true
  graphView: 'ILR.SandwichStructuredComposite.Views.Graph'

  graphDefaults:
    yAxisLabel: -> t('sandwichStructuredComposite.yAxisLabel')
    xAxisLabel: -> t('sandwichStructuredComposite.xAxisLabel')
    yOrigin: 30
    yOriginAnchor: 'top'
