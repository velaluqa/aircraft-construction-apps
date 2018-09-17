ILR.LiftDistribution ?= {}
ILR.LiftDistribution.Models ?= {}
class ILR.LiftDistribution.Models.App extends ILR.Models.BaseApp
  name: 'liftDistribution'
  path: 'liftDistribution'

  defaults: ->
    @loadAppSettings
      valueAtRange: 0
      axisLabelingForCurve: null
      calculators: []

  # Load persistent custom airplanes into the collection of available airplanes.
  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'aspectRatio'
      @loadFormFieldSettings 'linearTwist'
      @loadFormFieldSettings 'sweep'
      @loadFormFieldSettings 'taperRatio'
      @loadFormFieldSettings 'liftCoefficient'
      @loadFormFieldSettings 'cruisingSpeed'
    ]

    @displayParams = new Backbone.Model()

    @initCurves [
      @loadCurveSettings 'gamma'
      @loadCurveSettings 'gamma_a'
      @loadCurveSettings 'gamma_b'
      @loadCurveSettings 'elliptic'
      @loadCurveSettings 'C_a'
      @loadCurveSettings 'C_A'
      @loadCurveSettings 'geometry'
    ],
      limit: 6

    @set axisLabelingForCurve: @curves.getOldest()

    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()

    @attributes.calculators[0] = new ILR.LiftDistribution.Models.Calculator
      liftDistribution: this

    super
