ILR.SandwichStructuredComposite ?= {}
ILR.SandwichStructuredComposite.Models ?= {}
class ILR.SandwichStructuredComposite.Models.App extends ILR.Models.BaseApp
  name: 'sandwichStructuredComposite'
  path: 'sandwichStructuredComposite'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'width'
      @loadFormFieldSettings 'length'
      @loadFormFieldSettings 'height'
      @loadFormFieldSettings 'skinRatio'
      @loadFormFieldSettings 'load'
      @loadFormFieldSettings 'elasticModulusSkin'
      @loadFormFieldSettings 'shearModulusCore'
    ]

    @initCurves [
      @loadCurveSettings 'w_beam'
      @loadCurveSettings 'w_stress'
      @loadCurveSettings 'w_stress_ratio'
      @loadCurveSettings 'core_value'
      @loadCurveSettings 'w_total'
    ]

    @displayParams = new Backbone.Model
    calc = new ILR.SandwichStructuredComposite.Models.Calculator model: this
    @set calculators: [calc]

    super
