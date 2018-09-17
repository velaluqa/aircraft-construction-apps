ILR.JetEnginePerformance ?= {}
ILR.JetEnginePerformance.Models ?= {}
class ILR.JetEnginePerformance.Models.App extends ILR.Models.BaseSubappContainer
  name: 'jetEnginePerformance'
  path: 'jetEnginePerformance'

  subapps:
    thrust:
      model: 'ILR.JetEnginePerformance.Models.ThrustApp'
      view:  'ILR.JetEnginePerformance.Views.ThrustApp'
    consumption:
      model: 'ILR.JetEnginePerformance.Models.ConsumptionApp'
      view:  'ILR.JetEnginePerformance.Views.ConsumptionApp'
