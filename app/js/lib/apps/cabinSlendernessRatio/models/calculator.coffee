ILR.CabinSlendernessRatio ?= {}
ILR.CabinSlendernessRatio.Models ?= {}
class ILR.CabinSlendernessRatio.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  yRange: (func) -> 0.16
  xRange: (func) -> 500

  accuracy: 100

  STORAGE_INCLUDED_ABREAST: 5
  LONG_RANGE_ABREAST: 7

  f_ratio_lr:        @reactive 'f_ratio_lr',        -> @model.get('f_ratio_lr') / 100
  c_ratio_lr:        @reactive 'c_ratio_lr',        -> @model.get('c_ratio_lr') / 100
  m_aisleWidth:      @reactive 'm_aisleWidth',      -> @model.get('m_aisleWidth')
  f_seatWidth:       @reactive 'f_seatWidth',       -> @model.get('f_seatWidth') / 2.54
  c_seatWidth:       @reactive 'c_seatWidth',       -> @model.get('c_seatWidth') / 2.54
  m_seatWidth_lr:    @reactive 'm_seatWidth_lr',    -> @model.get('m_seatWidth_lr') / 2.54
  m_seatWidth_reg:   @reactive 'm_seatWidth_reg',   -> @model.get('m_seatWidth_reg') / 2.54
  m_abreast:         @reactive 'm_abreast',         -> @model.get('m_abreast')
  f_seatSpace:       @reactive 'f_seatSpace',       -> @model.get('f_seatSpace')
  c_seatSpace:       @reactive 'c_seatSpace',       -> @model.get('c_seatSpace')
  m_seatSpace:       @reactive 'm_seatSpace',       -> @model.get('m_seatSpace')
  f_seatPitch:       @reactive 'f_seatPitch',       -> @model.get('f_seatPitch')
  c_seatPitch:       @reactive 'c_seatPitch',       -> @model.get('c_seatPitch')
  m_seatPitch_lr:    @reactive 'm_seatPitch_lr',    -> @model.get('m_seatPitch_lr')
  m_seatPitch_reg:   @reactive 'm_seatPitch_reg',   -> @model.get('m_seatPitch_reg')
  f_serviceArea:     @reactive 'f_serviceArea',     -> @model.get('f_serviceArea')
  c_serviceArea:     @reactive 'c_serviceArea',     -> @model.get('c_serviceArea')
  m_serviceArea_lr:  @reactive 'm_serviceArea_lr',  -> @model.get('m_serviceArea_lr')
  m_serviceArea_reg: @reactive 'm_serviceArea_reg', -> @model.get('m_serviceArea_reg')
  f_stowage:         @reactive 'f_stowage',         -> @model.get('f_stowage')
  c_stowage:         @reactive 'c_stowage',         -> @model.get('c_stowage')
  m_stowage:         @reactive 'm_stowage',         -> @model.get('m_stowage')
  f_doorWidth:       @reactive 'f_doorWidth',       -> @model.get('f_doorWidth')
  c_doorWidth:       @reactive 'c_doorWidth',       -> @model.get('c_doorWidth')
  m_doorWidth:       @reactive 'm_doorWidth',       -> @model.get('m_doorWidth')
  f_doorInterval:    @reactive 'f_doorInterval',    -> @model.get('f_doorInterval') * 12
  c_doorInterval:    @reactive 'c_doorInterval',    -> @model.get('c_doorInterval') * 12
  m_doorInterval:    @reactive 'm_doorInterval',    -> @model.get('m_doorInterval') * 12

  m_ratio_lr: @reactive 'm_ratio_lr', ->
    1 - @f_ratio_lr() - @c_ratio_lr()

  f_aisleWidth: @reactive 'f_aisleWidth', ->
    @_f_aisleWidth(@m_abreast(), @width(@m_abreast()))

  _f_aisleWidth: @reactive '_f_aisleWidth', (m_abreast, width) ->
    (width - @_f_abreast(m_abreast, width) * @f_seatWidth() - @f_seatSpace()) / @aisleFactor(m_abreast)

  c_aisleWidth: @reactive 'c_aisleWidth', ->
    @_c_aisleWidth(@m_abreast(), @width(@m_abreast()))

  _c_aisleWidth: @reactive '_c_aisleWidth', (m_abreast, width) ->
    (width - @_c_abreast(m_abreast, width) * @c_seatWidth() - @c_seatSpace()) / @aisleFactor(m_abreast)

  f_abreast: @reactive 'f_abreast', ->
    @_f_abreast(@m_abreast(), @width(@m_abreast()))

  _f_abreast: @reactive '_f_abreast', (m_abreast, width) ->
    if m_abreast >= @LONG_RANGE_ABREAST
      Math.floor((width - @aisleFactor(m_abreast) * @m_aisleWidth() - @f_seatSpace()) / @f_seatWidth())
    else
      NaN

  c_abreast: @reactive 'c_abreast', ->
    @_c_abreast(@m_abreast(), @width(@m_abreast()))

  _c_abreast: @reactive '_c_abreast', (m_abreast, width) ->
    if m_abreast >= @LONG_RANGE_ABREAST
      Math.floor((width - @aisleFactor(m_abreast) * @m_aisleWidth() - @c_seatSpace()) / @c_seatWidth())
    else
      NaN

  aisleFactor: (abreast) ->
    if abreast > 10
      3
    else if abreast > 6
      2
    else
      1

  width: @reactive 'width', (m_abreast) ->
    if m_abreast < @LONG_RANGE_ABREAST
      seatWidth = @m_seatWidth_reg()
    else
      seatWidth = @m_seatWidth_lr()
    @aisleFactor(m_abreast) * @m_aisleWidth() + seatWidth * m_abreast + @m_seatSpace()

  _compartmentLength: @reactive '_compartmentLength', (cap, abreast, m_abreast, aisleWidth, seatWidth, seatPitch, serviceArea, stowage, doorWidth, doorInterval) ->
    if m_abreast < @STORAGE_INCLUDED_ABREAST
      stowageSummand = stowage / (aisleWidth / abreast + seatWidth)
    else
      stowageSummand = 0

    cap/abreast * (seatPitch + serviceArea / seatWidth + stowageSummand + doorWidth * (abreast/cap + seatPitch / doorInterval))

  length: @reactive 'length', (cap, m_abreast, width) ->
    if m_abreast < @LONG_RANGE_ABREAST
      @_compartmentLength(cap, m_abreast, m_abreast, @m_aisleWidth(), @m_seatWidth_reg(), @m_seatPitch_reg(), @m_serviceArea_reg(), @m_stowage(), @m_doorWidth(), @m_doorInterval())
    else
      @_compartmentLength(@f_ratio_lr() * cap, @_f_abreast(m_abreast, width), m_abreast, @_f_aisleWidth(m_abreast, width), @f_seatWidth(), @f_seatPitch(), @f_serviceArea(), @f_stowage(), @f_doorWidth(), @f_doorInterval()) +
      @_compartmentLength(@c_ratio_lr() * cap, @_c_abreast(m_abreast, width), m_abreast, @_c_aisleWidth(m_abreast, width), @c_seatWidth(), @c_seatPitch(), @c_serviceArea(), @c_stowage(), @c_doorWidth(), @c_doorInterval()) +
      @_compartmentLength(@m_ratio_lr() * cap, m_abreast, m_abreast, @m_aisleWidth(), @m_seatWidth_lr(), @m_seatPitch_lr(), @m_serviceArea_lr(), @m_stowage(), @m_doorWidth(), @m_doorInterval())

  _wlr: @reactive '_wlr', (cap, m_abreast) ->
    width = @width(m_abreast)
    width / @length(cap, m_abreast, width)

  _cap: @reactive '_cap', (r, m_abreast) ->
    if m_abreast < @LONG_RANGE_ABREAST
      if m_abreast < @STORAGE_INCLUDED_ABREAST
        stowageSummand = @m_stowage() / (@m_aisleWidth() / m_abreast + @m_seatWidth_reg())
      else
        stowageSummand = 0
      (@aisleFactor(m_abreast) * @m_aisleWidth() + @m_seatWidth_reg() * m_abreast + @m_seatSpace() - @m_doorWidth() * r) / (r/m_abreast * (@m_seatPitch_reg() + @m_serviceArea_reg() / @m_seatWidth_reg() + stowageSummand + @m_doorWidth() * @m_seatPitch_reg() / @m_doorInterval()))
    else
      width = @width(m_abreast)
      f_s = @f_ratio_lr() / @_f_abreast(m_abreast, width) * (@f_seatPitch() + @f_serviceArea() / @f_seatWidth() + @f_doorWidth() * @f_seatPitch() / @f_doorInterval())
      c_s = @c_ratio_lr() / @_c_abreast(m_abreast, width) * (@c_seatPitch() + @c_serviceArea() / @c_seatWidth() + @c_doorWidth() * @c_seatPitch() / @c_doorInterval())
      m_s = @m_ratio_lr() / m_abreast * (@m_seatPitch_lr() + @m_serviceArea_lr() / @m_seatWidth_lr() + @m_doorWidth() * @m_seatPitch_lr() / @m_doorInterval())
      ((@aisleFactor(m_abreast) * @m_aisleWidth() + @m_seatWidth_lr() * m_abreast + @m_seatSpace()) / r - @f_doorWidth() - @c_doorWidth() - @m_doorWidth()) / (f_s + c_s + m_s)

  wlr_var: @reactive 'r_var', (m_abreast) ->
    points = []

    for r in [0.05..0.2001] by 0.0025
      points.push(@_cap(r, m_abreast), r)

    return {
      points: points,
      tension: 0.5
    }

  wlr:    @memoize 'wlr',    -> @wlr_var(@m_abreast())
  wlr_2:  @memoize 'wlr_2',  -> @wlr_var(2)
  wlr_3:  @memoize 'wlr_3',  -> @wlr_var(3)
  wlr_4:  @memoize 'wlr_4',  -> @wlr_var(4)
  wlr_5:  @memoize 'wlr_5',  -> @wlr_var(5)
  wlr_6:  @memoize 'wlr_6',  -> @wlr_var(6)
  wlr_7:  @memoize 'wlr_7',  -> @wlr_var(7)
  wlr_8:  @memoize 'wlr_8',  -> @wlr_var(8)
  wlr_9:  @memoize 'wlr_9',  -> @wlr_var(9)
  wlr_10: @memoize 'wlr_10', -> @wlr_var(10)
  wlr_value:    @reactive 'wlr_value',    (cap) -> @_wlr(cap, @m_abreast())
  wlr_2_value:  @reactive 'wlr_2_value',  (cap) -> @_wlr(cap, 2)
  wlr_3_value:  @reactive 'wlr_3_value',  (cap) -> @_wlr(cap, 3)
  wlr_4_value:  @reactive 'wlr_4_value',  (cap) -> @_wlr(cap, 4)
  wlr_5_value:  @reactive 'wlr_5_value',  (cap) -> @_wlr(cap, 5)
  wlr_6_value:  @reactive 'wlr_6_value',  (cap) -> @_wlr(cap, 6)
  wlr_7_value:  @reactive 'wlr_7_value',  (cap) -> @_wlr(cap, 7)
  wlr_8_value:  @reactive 'wlr_8_value',  (cap) -> @_wlr(cap, 8)
  wlr_9_value:  @reactive 'wlr_9_value',  (cap) -> @_wlr(cap, 9)
  wlr_10_value: @reactive 'wlr_10_value', (cap) -> @_wlr(cap, 10)

  lowerBound_value: (cap) ->
    0.258904909668636 * Math.pow(cap, -0.186462329451493)

  upperBound_value: (cap) ->
    0.253215018481292 * Math.pow(cap, -0.102238805712512)

  lowerBound: (xMin = 0, xMax = 0) ->
    points = []

    # no xMin lower than 1/Math.pow(5*0.258904909668636, 1/-0.186462329451493)
    xMin = Math.max(xMin, 3.992537530085134)

    if xMax > xMin
      cap = xMin
      stepSize = (xMax - xMin) / @accuracy
      xMax += stepSize
      for cap in [xMin..xMax] by stepSize
        points.push(cap, @lowerBound_value(cap))

    return {
      points: points,
      tension: 0.5
    }

  upperBound: (xMin = 0, xMax = 0) ->
    points = []

    # no xMin lower than 1/Math.pow(5*0.253215018481292, 1/-0.102238805712512)
    xMin = Math.max(xMin, 10.049819761382384)

    if xMax > xMin
      cap = xMin
      stepSize = (xMax - xMin) / @accuracy
      xMax += stepSize
      for cap in [xMin..xMax] by stepSize
        points.push(cap, @upperBound_value(cap))

    return {
      points: points,
      tension: 0.5
    }
