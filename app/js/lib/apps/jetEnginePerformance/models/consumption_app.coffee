ILR.JetEnginePerformance ?= {}
ILR.JetEnginePerformance.Models ?= {}
class ILR.JetEnginePerformance.Models.ConsumptionApp extends ILR.Models.BaseApp
  name: 'jetEnginePerformanceConsumption'
  path: 'jetEnginePerformance/consumption'

  defaults: ->
    @loadAppSettings
      valueAtRange: 0

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'mu'
      @loadFormFieldSettings 'height'
      @loadFormFieldSettings 'TET'
      @loadFormFieldSettings 'OAPR'
      @loadFormFieldSettings 'eta_c'
      @loadFormFieldSettings 'eta_f'
      @loadFormFieldSettings 'eta_n'
      @loadFormFieldSettings 'eta_t'
      @loadFormFieldSettings 'deltaP'
    ]

    @initCurves [
      @loadCurveSettings 'SFC'
      @loadCurveSettings 'SFC_m0'
      @loadCurveSettings 'SFC_m2'
      @loadCurveSettings 'SFC_m4'
      @loadCurveSettings 'SFC_m6'
      @loadCurveSettings 'SFC_m8'
      @loadCurveSettings 'SFC_m10'
    ]

    @displayParams = new Backbone.Model()
    @set calculators: [new ILR.JetEnginePerformance.Models.ConsumptionCalculator(consumptionApp: this)]
    @set axisLabelingForCurve: @curves.first()

    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()

    super
