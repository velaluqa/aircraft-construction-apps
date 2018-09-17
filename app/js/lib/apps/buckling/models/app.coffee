ILR.Buckling ?= {}
ILR.Buckling.Models ?= {}
class ILR.Buckling.Models.App extends ILR.Models.BaseApp
  name: 'buckling'
  path: 'buckling'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'stiffenings'
      @loadFormFieldSettings 'yx_ratio'
    ]

    @initCurves [
      @loadCurveSettings 'bucklingValue_1'
      @loadCurveSettings 'bucklingValue_2'
      @loadCurveSettings 'bucklingValue_3'
      @loadCurveSettings 'bucklingValue_4'
      @loadCurveSettings 'bucklingValue_5'
      @loadCurveSettings 'bucklingValue_6'
      @loadCurveSettings 'festoon'
    ]

    @displayParams = new Backbone.Model
    @set calculators: [new ILR.Buckling.Models.Calculator(model: this)]

    super
