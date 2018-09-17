ILR.CabinSlendernessRatio ?= {}
ILR.CabinSlendernessRatio.Models ?= {}
class ILR.CabinSlendernessRatio.Models.App extends ILR.Models.BaseApp
  name: 'cabinSlendernessRatio'
  path: 'cabinSlendernessRatio'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'standard', type: 'value'
      @loadFormFieldSettings 'f_abreast', type: 'value'
      @loadFormFieldSettings 'c_abreast', type: 'value'
      @loadFormFieldSettings 'm_abreast'
      @loadFormFieldSettings 'f_ratio_lr'
      @loadFormFieldSettings 'c_ratio_lr'
      @loadFormFieldSettings 'm_ratio_lr', type: 'value'
      @loadFormFieldSettings 'f_aisleWidth', type: 'value'
      @loadFormFieldSettings 'c_aisleWidth', type: 'value'
      @loadFormFieldSettings 'm_aisleWidth'
      @loadFormFieldSettings 'f_seatWidth'
      @loadFormFieldSettings 'c_seatWidth'
      @loadFormFieldSettings 'm_seatWidth_lr'
      @loadFormFieldSettings 'm_seatWidth_reg'
      @loadFormFieldSettings 'f_seatPitch'
      @loadFormFieldSettings 'c_seatPitch'
      @loadFormFieldSettings 'm_seatPitch_lr'
      @loadFormFieldSettings 'm_seatPitch_reg'
      @loadFormFieldSettings 'f_serviceArea'
      @loadFormFieldSettings 'c_serviceArea'
      @loadFormFieldSettings 'm_serviceArea_lr'
      @loadFormFieldSettings 'm_serviceArea_reg'
      @loadFormFieldSettings 'f_stowage'
      @loadFormFieldSettings 'c_stowage'
      @loadFormFieldSettings 'm_stowage'
      @loadFormFieldSettings 'f_seatSpace'
      @loadFormFieldSettings 'c_seatSpace'
      @loadFormFieldSettings 'm_seatSpace'
      @loadFormFieldSettings 'f_doorWidth'
      @loadFormFieldSettings 'c_doorWidth'
      @loadFormFieldSettings 'm_doorWidth'
      @loadFormFieldSettings 'f_doorInterval'
      @loadFormFieldSettings 'c_doorInterval'
      @loadFormFieldSettings 'm_doorInterval'
    ]

    @initCurves [
      @loadCurveSettings 'wlr', zIndex: 1
      @loadCurveSettings 'wlr_2'
      @loadCurveSettings 'wlr_3'
      @loadCurveSettings 'wlr_4'
      @loadCurveSettings 'wlr_5'
      @loadCurveSettings 'wlr_6'
      @loadCurveSettings 'wlr_7'
      @loadCurveSettings 'wlr_8'
      @loadCurveSettings 'wlr_9'
      @loadCurveSettings 'wlr_10'
      @loadCurveSettings 'upperBound'
      @loadCurveSettings 'lowerBound'
    ]

    @displayParams = new Backbone.Model
    calc = new ILR.CabinSlendernessRatio.Models.Calculator model: this
    @set calculators: [calc]

    @set f_abreast: calc.f_abreast()
    @listenTo calc, 'change:f_abreast', -> @set f_abreast: calc.f_abreast()
    @set c_abreast: calc.c_abreast()
    @listenTo calc, 'change:c_abreast', -> @set c_abreast: calc.c_abreast()

    @set f_aisleWidth: calc.f_aisleWidth()
    @listenTo calc, 'change:f_aisleWidth', -> @set f_aisleWidth: calc.f_aisleWidth()
    @set c_aisleWidth: calc.c_aisleWidth()
    @listenTo calc, 'change:c_aisleWidth', -> @set c_aisleWidth: calc.c_aisleWidth()

    @set m_ratio_lr: calc.m_ratio_lr() * 100
    @listenTo calc, 'change:m_ratio_lr', -> @set m_ratio_lr: calc.m_ratio_lr() * 100

    @on 'change:f_ratio_lr', (_, value) ->
      if value + @get('c_ratio_lr') > 100
        @set('c_ratio_lr', 100 - value)

    @on 'change:c_ratio_lr', (_, value) ->
      if value + @get('f_ratio_lr') > 100
        @set('f_ratio_lr', 100 - value)

    @on 'change:m_abreast', (_, value) ->
      if value < calc.LONG_RANGE_ABREAST
        @set('standard', 'Regional')
      else
        @set('standard', 'LR')

    super
