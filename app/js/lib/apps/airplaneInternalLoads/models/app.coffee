ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Models ?= {}
class ILR.AirplaneInternalLoads.Models.App extends ILR.Models.BaseSubappContainer
  name: 'airplaneInternalLoads'
  path: 'airplaneInternalLoads'

  subapps:
    wing:
      model: 'ILR.AirplaneInternalLoads.Models.WingApp'
      view:  'ILR.AirplaneInternalLoads.Views.WingApp'
    fuselage:
      model: 'ILR.AirplaneInternalLoads.Models.FuselageApp'
      view:  'ILR.AirplaneInternalLoads.Views.FuselageApp'
