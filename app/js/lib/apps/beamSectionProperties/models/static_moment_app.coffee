ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.StaticMomentApp extends ILR.Models.BaseApp
  name: 'beamSectionPropertiesStaticMoment'
  path: 'beamSectionProperties/staticMoment'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'coord', options: ['eigen', 'none']
      @loadFormFieldSettings 'za'
      @loadFormFieldSettings 'l'
      @loadFormFieldSettings 't'
      @loadFormFieldSettings 'alpha'
      @loadFormFieldSettings 'z0'
      @loadFormFieldSettings 'IntSz', type: 'value'
      @loadFormFieldSettings 'Iy', type: 'value'
      @loadFormFieldSettings 'z0element', type: 'value'
    ]

    @initCurves [
      @loadCurveSettings 'profile'
      @loadCurveSettings 'Sz'
      @loadCurveSettings 'Ss'
      @loadCurveSettings 'neutralAxis'
    ]

    @displayParams = new Backbone.Model()
    calc = new ILR.BeamSectionProperties.Models.StaticMomentCalculator model: this
    @set calculators: [calc]

    @set Iy: calc.Iy()
    @set IntSz: calc.IntSz()
    @set z0element: calc.z0element()
    @listenTo calc, 'change:Iy',        => @set Iy: calc.Iy()
    @listenTo calc, 'change:IntSz',     => @set IntSz: calc.IntSz()
    @listenTo calc, 'change:z0element', => @set z0element: calc.z0element()

    super
