ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.HalfCircleApp extends ILR.Models.BaseApp
  name: 'beamSectionPropertiesHalfCircle'
  path: 'beamSectionProperties/halfCircle'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'baseThickness'
      @loadFormFieldSettings 'relBaseThickness'
      @loadFormFieldSettings 'averageRadius', type: 'number'
    ]
    @initCurves [@loadCurveSettings('profile')]

    @displayParams = new Backbone.Model()
    @set calculators: [new ILR.BeamSectionProperties.Models.HalfCircleCalculator model: this]
    @set axisLabelingForCurve: @curves.first()

    super
