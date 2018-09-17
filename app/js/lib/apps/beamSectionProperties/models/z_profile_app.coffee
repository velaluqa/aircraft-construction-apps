ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.ZProfileApp extends ILR.Models.BaseApp
  name: 'beamSectionPropertiesZProfile'
  path: 'beamSectionProperties/zProfile'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'b'
      @loadFormFieldSettings 'h'
      @loadFormFieldSettings 'tf'
      @loadFormFieldSettings 'ts'
      @loadFormFieldSettings 'alfa'
      @loadFormFieldSettings 'IyAlphaX', type: 'value'
      @loadFormFieldSettings 'IzAlphaX', type: 'value'
      @loadFormFieldSettings 'IyzAlphaX', type: 'value'
      @loadFormFieldSettings 'Iy_h', type: 'value'
      @loadFormFieldSettings 'Iz_h', type: 'value'
    ]

    @initCurves [
      @loadCurveSettings 'baseProfile'
      @loadCurveSettings 'rotProfile'
    ]

    calc = new ILR.BeamSectionProperties.Models.ZProfileCalculator model: this
    @set calculators: [calc]

    @set IyAlphaX:  calc.IyAlphaX()
    @set IzAlphaX:  calc.IzAlphaX()
    @set IyzAlphaX: calc.IyzAlphaX()
    @set Iy_h: calc.Iy_h()
    @set Iz_h: calc.Iz_h()
    @listenTo calc, 'change:IyAlphaX',  => @set IyAlphaX:  calc.IyAlphaX()
    @listenTo calc, 'change:IzAlphaX',  => @set IzAlphaX:  calc.IzAlphaX()
    @listenTo calc, 'change:IyzAlphaX', => @set IyzAlphaX: calc.IyzAlphaX()
    @listenTo calc, 'change:Iz_h', => @set Iz_h: calc.Iz_h()
    @listenTo calc, 'change:Iy_h', => @set Iy_h: calc.Iy_h()

    super
