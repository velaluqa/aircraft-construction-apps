ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.App extends ILR.Models.BaseSubappContainer
  name: 'beamSectionProperties'
  path: 'beamSectionProperties'

  subapps:
    uProfile:
      model: 'ILR.BeamSectionProperties.Models.UProfileApp'
      view:  'ILR.BeamSectionProperties.Views.UProfileApp'
    halfCircle:
      model: 'ILR.BeamSectionProperties.Models.HalfCircleApp'
      view:  'ILR.BeamSectionProperties.Views.HalfCircleApp'
    staticMoment:
      model: 'ILR.BeamSectionProperties.Models.StaticMomentApp'
      view:  'ILR.BeamSectionProperties.Views.StaticMomentApp'
    zProfile:
      model: 'ILR.BeamSectionProperties.Models.ZProfileApp'
      view:  'ILR.BeamSectionProperties.Views.ZProfileApp'
