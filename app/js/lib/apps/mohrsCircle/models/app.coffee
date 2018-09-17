ILR.MohrsCircle ?= {}
ILR.MohrsCircle.Models ?= {}
class ILR.MohrsCircle.Models.App extends ILR.Models.BaseApp
  name: 'mohrsCircle'
  path: 'mohrsCircle'

  defaults: ->
    @loadAppSettings
      axisLabelingForCurve: null
      calculators: []

  # Load persistent custom airplanes into the collection of available airplanes.
  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'nx'
      @loadFormFieldSettings 'ny'
      @loadFormFieldSettings 'nxy'
      @loadFormFieldSettings 'alpha'
      @loadFormFieldSettings 'nX', type: 'value'
      @loadFormFieldSettings 'nY', type: 'value'
      @loadFormFieldSettings 'nXY', type: 'value'
      @loadFormFieldSettings 'n1', type: 'value'
      @loadFormFieldSettings 'n2', type: 'value'
      @loadFormFieldSettings 'x0', type: 'value'
      @loadFormFieldSettings 'R', type: 'value'
    ]

    @displayParams = new Backbone.Model()
    @initCurves [
      @loadCurveSettings 'transformedSectionForce'
      @loadCurveSettings 'sectionForce'
      @loadCurveSettings 'circle'
    ],
      limit: 3

    calc = new ILR.MohrsCircle.Models.Calculator(model: this)
    @set calculators: [calc]
    @set axisLabelingForCurve: @curves.first()

    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()

    @set nX: calc.nX()
    @listenTo calc, 'change:nX',  -> @set nX: calc.nX()
    @set nY: calc.nY()
    @listenTo calc, 'change:nY',  -> @set nY: calc.nY()
    @set nXY: calc.nXY()
    @listenTo calc, 'change:nXY', -> @set nXY: calc.nXY()
    @set n1: calc.n1()
    @listenTo calc, 'change:n1',  -> @set n1: calc.n1()
    @set n2: calc.n2()
    @listenTo calc, 'change:n2',  -> @set n2: calc.n2()
    @set x0: calc.x0()
    @listenTo calc, 'change:x0',  -> @set x0: calc.x0()
    @set R: calc.R()
    @listenTo calc, 'change:R',   -> @set R: calc.R()

    super
