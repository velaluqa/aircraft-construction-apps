ILR.InternationalStandardAtmosphere ?= {}
ILR.InternationalStandardAtmosphere.Models ?= {}
class ILR.InternationalStandardAtmosphere.Models.App extends ILR.Models.BaseApp
  name: 'internationalStandardAtmosphere'
  path: 'internationalStandardAtmosphere'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'deltaTemperature'
      @loadFormFieldSettings 'seaLevelTemperature', type: 'value'
    ]

    @initCurves [
      @loadCurveSettings 'pressure'
      @loadCurveSettings 'relativePressure'
      @loadCurveSettings 'density'
      @loadCurveSettings 'relativeDensity'
      @loadCurveSettings 'temperature'
      @loadCurveSettings 'relativeTemperature'
      @loadCurveSettings 'speedOfSound'
      @loadCurveSettings 'dynamicViscosity'
      @loadCurveSettings 'kinematicViscosity'
    ]

    @displayParams = new Backbone.Model
    calc = new ILR.InternationalStandardAtmosphere.Models.Calculator model: this
    @set calculators: [calc]
    @set axisLabelingForCurve: @curves.first()

    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()

    @listenTo calc, 'change:seaLevelTemperature', -> @set seaLevelTemperature: calc.seaLevelTemperature()
    @set seaLevelTemperature: calc.seaLevelTemperature()

    for attr in ['pressure', 'relativePressure', 'density', 'relativeDensity',
                 'temperature', 'relativeTemperature', 'speedOfSound',
                 'dynamicViscosity', 'kinematicViscosity']
      do (attr) =>
        updateModel = =>
          @set("#{attr}_value", calc["#{attr}_value"](@get('altitude')))
        calc.on "change:#{attr}_value", updateModel
        @on 'change:altitude', updateModel
        updateModel()

    super
