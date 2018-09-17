ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Models ?= {}
class ILR.AirplaneInternalLoads.Models.WingApp extends ILR.Models.BaseApp
  name: 'airplaneWingInternalLoads'
  path: 'airplaneInternalLoads/wing'

  defaults: ->
    @loadAppSettings
      axisLabelingForCurve: null
      valueAtRange: 0

  initialize: ->
    @initCurves [
      @loadCurveSettings 'lift'
      @loadCurveSettings 'structure'
      @loadCurveSettings 'fuel'
      @loadCurveSettings 'total'
      @loadCurveSettings 'Q'
      @loadCurveSettings 'M'
      @loadCurveSettings 'T'
    ],
      limit: 4

    @displayParams = new Backbone.Model()

    @calc = new ILR.AirplaneInternalLoads.Models.WingCalculator model: this
    @set calculators: [@calc]
    @listenTo @calc, 'change:wingArea',   -> @set(wingArea:   @calc.wingArea())
    @listenTo @calc, 'change:innerChord', -> @set(innerChord: @calc.innerChord())
    @listenTo @calc, 'change:outerChord', -> @set(outerChord: @calc.outerChord())
    @listenTo @calc, 'change:mac',        -> @set(mac:        @calc.mac())
    @set(wingArea:   @calc.wingArea())
    @set(innerChord: @calc.innerChord())
    @set(outerChord: @calc.outerChord())
    @set(mac:        @calc.mac())

    @set axisLabelingForCurve: @curves.findWhere(function: 'total')

    @on 'change:relGearPositionY', () =>
      rGP = @get('relGearPositionY')
      rEP = @get('relEnginePositionY')
      @set(relEnginePositionY: rGP) if rGP > rEP
    @on 'change:relEnginePositionY', =>
      rGP = @get('relGearPositionY')
      rEP = @get('relEnginePositionY')
      rTS = @get('relTankSpan')
      @set(relGearPositionY: rEP) if rEP < rGP
      @set(relTankSpan: rEP) if rEP > rTS
    @on 'change:relTankSpan', ->
      rGP = @get('relGearPositionY')
      rEP = @get('relEnginePositionY')
      rTS = @get('relTankSpan')
      @set(relEnginePositionY: rTS) if rTS < rEP

    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()

    super
