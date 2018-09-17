ILR.JetEnginePerformance ?= {}
ILR.JetEnginePerformance.Models ?= {}
class ILR.JetEnginePerformance.Models.ThrustApp extends ILR.Models.BaseApp
  name: 'jetEnginePerformanceThrust'
  path: 'jetEnginePerformance/thrust'

  defaults: ->
    @loadAppSettings
      valueAtRange: 0

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'mu'
      @loadFormFieldSettings 'height'
      @loadFormFieldSettings 'D'
      @loadFormFieldSettings 'deltaP'
    ]

    @initCurves [
      @loadCurveSettings 'SS'
      @loadCurveSettings 'SS_m0'
      @loadCurveSettings 'SS_m2'
      @loadCurveSettings 'SS_m4'
      @loadCurveSettings 'SS_m6'
      @loadCurveSettings 'SS_m8'
      @loadCurveSettings 'SS_m10'
    ]

    @displayParams = new Backbone.Model()
    @set calculators: [new ILR.JetEnginePerformance.Models.ThrustCalculator(thrustApp: this)]
    @set axisLabelingForCurve: @curves.first()

    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()

    super
