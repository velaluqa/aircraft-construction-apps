ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Models ?= {}
class ILR.AirplaneInternalLoads.Models.WingCalculator extends ILR.Models.BaseCalculator
  curveGroups: [['lift', 'structure', 'fuel', 'total'], ['T', 'M', 'Q']]

  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  interpolationTension: 0
  accuracy: 25

  loadCase:            @reactive 'loadCase',            -> @model.get('loadCase')
  thrust:              @reactive 'thrust',              -> @model.get('thrust') * 1000
  loadFactor:          @reactive 'loadFactor',          -> @model.get('loadFactor')
  airplaneMass:        @reactive 'airplaneMass',        -> @model.get('airplaneMass')
  relWingMass:         @reactive 'relWingMass',         -> @model.get('relWingMass') / 100
  relFuelMass:         @reactive 'relFuelMass',         -> @model.get('relFuelMass') / 100
  relEngineMass:       @reactive 'relEngineMass',       -> @model.get('relEngineMass') / 100
  relPayload:          @reactive 'relPayload',          -> @model.get('relPayload') / 100

  span:                @reactive 'span',                -> @model.get('span')
  aspectRatio:         @reactive 'aspectRatio',         -> @model.get('aspectRatio')
  taper:               @reactive 'taper',               -> @model.get('taper')

  relGearPositionX:    @reactive 'relGearPositionX',    -> @model.get('relGearPositionX')  / 100
  relGearPositionY:    @reactive 'relGearPositionY',    -> @model.get('relGearPositionY') / 100
  relTankSpan:         @reactive 'relTankSpan',         -> @model.get('relTankSpan') / 100
  relShearCenter:      @reactive 'relShearCenter',      -> @model.get('relShearCenter') / 100
  relEnginePositionY:  @reactive 'relEnginePositionY',  -> @model.get('relEnginePositionY') / 100
  relThrustCenterZ:    @reactive 'relThrustCenterZ',    -> @model.get('relThrustCenterZ') / 100

  wingMass:            @reactive 'wingMass',            -> @airplaneMass() * @relWingMass()
  fuelMass:            @reactive 'fuelMass',            -> @airplaneMass() * @relFuelMass()
  engineMass:          @reactive 'engineMass',          -> @airplaneMass() * @relEngineMass()
  payloadMass:         @reactive 'payloadMass',         -> @airplaneMass() * @relPayload()

  tankSpan:            @reactive 'tankSpan',            -> @span() * @relTankSpan()
  tankAspectRatio:     @reactive 'tankAspectRatio',     -> @tankSpan() / @tankMac()
  tankTaper:           @reactive 'tankTaper',           -> @tankOuterChord() / @tankInnerChord()
  tankArea:            @reactive 'tankArea',            -> @tankSpan() * @tankMac()
  tankInnerChord:      @reactive 'tankInnerChord',      -> @innerChord()
  tankOuterChord:      @reactive 'tankOuterChord',      -> @innerChord() * (1 - @relTankSpan() * (1 - @taper()))
  tankMac:             @reactive 'tankMac',             -> @tankInnerChord() * (1 + @tankTaper()) / 2

  liftPowerPosition:   @reactive 'liftPowerPosition',   -> 0.25
  wingPowerPosition:   @reactive 'wingPowerPosition',   -> 0.45
  fuelPowerPosition:   @reactive 'fuelPowerPosition',   -> 0.45
  enginePowerPosition: @reactive 'enginePowerPosition', -> -0.3

  wingArea:            @reactive 'wingArea',            -> @span() * @mac()
  innerChord:          @reactive 'innerChord',          -> 2 * @mac() / (1 + @taper())
  outerChord:          @reactive 'outerChord',          -> @taper() * @innerChord()
  mac:                 @reactive 'mac',                 -> @span() / @aspectRatio()

  delta: 0.05

  flight: @reactive 'flight', ->
    @loadCase() is 'flight'

  y: @reactive 'y', (x) -> x * @span() / 2
  l: @reactive 'l', (x) -> @innerChord() * (1 - x * (1 - @taper()))

  liftFactor: @reactive 'liftFactor', ->
    if @flight()
      @airplaneMass() / @wingArea() * @loadFactor() * 9.81
    else
      0

  lift_value: @reactive 'lift_value', (x) ->
    @liftFactor() * @l(x) if 0 <= x <= 1

  lift: @memoize 'lift', ->
    minY = null
    maxY = null
    points = []
    for x in [0, 1]
      y = @lift_value(x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  structureFactor: @reactive 'structureFactor', ->
    - @wingMass() / @wingArea() * @loadFactor() * 9.81

  structure_value: @reactive 'structure_value', (x) ->
    @structureFactor() * @l(x) if 0 <= x <= 1

  structure: @memoize 'structure', ->
    minY = null
    maxY = null
    points = []
    for x in [0, 1]
      y = @structure_value(x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  fuelFactor: @reactive 'fuelFactor', ->
    - @fuelMass() / @tankArea() * @loadFactor() * 9.81

  fuel_value: @reactive 'fuel_value', (x) ->
    if 0 <= x <= @relTankSpan()
      @fuelFactor() * @l(x)
    else if @relTankSpan() < x <= 1.0
      0

  fuel: @memoize 'fuel', ->
    minY = null
    maxY = null
    points = []
    updateMinMax = (y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
    relTankSpan = @relTankSpan()
    for x in [0, relTankSpan]
      y = @fuel_value(x)
      updateMinMax(y)
      points.push(x, y)
    points.push(relTankSpan, 0)
    points.push(1, 0)
    updateMinMax(0)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  total_value: @reactive 'total_value', (x) ->
    rTS = @relTankSpan()
    if 0 <= x <= rTS
      (@liftFactor() + @structureFactor() + @fuelFactor()) * @l(x)
    else if rTS < x <= 1.0
      (@liftFactor() + @structureFactor()) * @l(x)

  total: @memoize 'total', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)
    relTankSpan = @relTankSpan()
    for x in [0, relTankSpan]
      y = (@liftFactor() + @structureFactor() + @fuelFactor()) * @l(x)
      pushPair(x, y)
    for x in [relTankSpan, 1]
      y = (@liftFactor() + @structureFactor()) * @l(x)
      pushPair(x, y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  Qa: @reactive 'Qa', (x) ->
    c3 = - @liftFactor() * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(1.0), 2) - @y(1.0))
    @liftFactor()        * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(x),   2) - @y(x)  ) + c3

  Qm: @reactive 'Qm', (x) ->
    rTS = @relTankSpan()
    c1 = - @structureFactor() * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(1.0), 2) - @y(1.0))
    c2 = c1 - @fuelFactor()   * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(rTS), 2) - @y(rTS))
    if 0 <= x <= rTS
      (@structureFactor() + @fuelFactor()) * @innerChord() * (- @y(x) + (1 - @taper()) / @span() * Math.pow(@y(x), 2)) + c2
    else if rTS < x <= 1.0
      @structureFactor() * @innerChord() * (- @y(x) + (1 - @taper()) / @span() * Math.pow(@y(x), 2)) + c1

  Q_value: @reactive 'Q_value', (x) ->
    sum = @Qa(x) + @Qm(x)
    if x <= @relEnginePositionY()
      sum -= @engineMass()/2 * @loadFactor() * 9.81
    if !@flight() and x <= @relGearPositionY()
      sum += @airplaneMass()/2 * @loadFactor() * 9.81
    sum

  Q: @memoize 'Q', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    rGP = if @flight() then 0 else @relGearPositionY()
    rEP = @relEnginePositionY()
    rTS = @relTankSpan()

    F4 = @structureFactor() + @liftFactor()
    F3 = @structureFactor() + @liftFactor() + @fuelFactor()

    c4 =    -  F4       * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(1.0), 2) - @y(1.0))
    c3 = c4 + (F4 - F3) * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(rTS), 2) - @y(rTS))
    c2 = c3 -   @engineMass()/2 * @loadFactor() * 9.81
    c1 = c2 + @airplaneMass()/2 * @loadFactor() * 9.81

    unless rGP is 0
      for i in [0..@accuracy]
        x = 0 + rGP * i/@accuracy
        y = F3 * @innerChord() * ((1 - @taper()) / @span() * Math.pow(@y(x), 2) - @y(x)) + c1
        pushPair(x, y)
    for i in [0..@accuracy]
      x = rGP + (rEP - rGP) * i/@accuracy
      y = F3 * @innerChord() * ((1 - @taper()) / @span() * Math.pow(@y(x), 2) - @y(x)) + c2
      pushPair(x, y)
    for i in [0..@accuracy]
      x = rEP + (rTS - rEP) * i/@accuracy
      y = F3 * @innerChord() * ((1 - @taper()) / @span() * Math.pow(@y(x), 2) - @y(x)) + c3
      pushPair(x, y)
    for i in [0..@accuracy]
      x = rTS + (1 - rTS) * i/@accuracy
      y = F4 * @innerChord() * ((1 - @taper()) / @span() * Math.pow(@y(x), 2) - @y(x)) + c4
      pushPair(x, y)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: @interpolationTension
    }

  M_value: (x) ->
    rGP = if @flight() then 0 else @relGearPositionY()
    rEP = @relEnginePositionY()
    rTS = @relTankSpan()

    F4 = @structureFactor() + @liftFactor()
    F3 = @structureFactor() + @liftFactor() + @fuelFactor()

    _c4 =     -  F4       * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(1.0), 2) - @y(1.0))
    _c3 = _c4 + (F4 - F3) * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(rTS), 2) - @y(rTS))
    _c2 = _c3 -   @engineMass()/2 * @loadFactor() * 9.81
    _c1 = _c2 + @airplaneMass()/2 * @loadFactor() * 9.81

    c4 =    -  F4       * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(1.0), 3) - 1/2 * Math.pow(@y(1.0), 2)) -  _c4        * @y(1.0)
    c3 = c4 + (F4 - F3) * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(rTS), 3) - 1/2 * Math.pow(@y(rTS), 2)) + (_c4 - _c3) * @y(rTS)
    c2 = c3 + (_c3 - _c2) * @y(rEP)
    c1 = c2 + (_c2 - _c1) * @y(rGP)

    if 0 <= x <= rGP
      - F3 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c1 * @y(x) - c1
    else if rGP < x <= rEP
      - F3 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c2 * @y(x) - c2
    else if rEP < x <= rTS
      - F3 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c3 * @y(x) - c3
    else if rTS < x <= 1.0
      - F4 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c4 * @y(x) - c4

  M: ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    rGP = if @flight() then 0 else @relGearPositionY()
    rEP = @relEnginePositionY()
    rTS = @relTankSpan()

    F4 = @structureFactor() + @liftFactor()
    F3 = @structureFactor() + @liftFactor() + @fuelFactor()

    _c4 =     -  F4       * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(1.0), 2) - @y(1.0))
    _c3 = _c4 + (F4 - F3) * @innerChord() * ((1 - @taper())/@span() * Math.pow(@y(rTS), 2) - @y(rTS))
    _c2 = _c3 -   @engineMass()/2 * @loadFactor() * 9.81
    _c1 = _c2 + @airplaneMass()/2 * @loadFactor() * 9.81

    c4 =    -  F4       * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(1.0), 3) - 1/2 * Math.pow(@y(1.0), 2)) -  _c4        * @y(1.0)
    c3 = c4 + (F4 - F3) * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(rTS), 3) - 1/2 * Math.pow(@y(rTS), 2)) + (_c4 - _c3) * @y(rTS)
    c2 = c3 + (_c3 - _c2) * @y(rEP)
    c1 = c2 + (_c2 - _c1) * @y(rGP)

    unless rGP is 0
      for i in [0..@accuracy]
        x = 0 + rGP * i/@accuracy
        y = - F3 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c1 * @y(x) - c1
        pushPair(x, y)
    for i in [0..@accuracy]
      x = rGP + (rEP - rGP) * i/@accuracy
      y = - F3 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c2 * @y(x) - c2
      pushPair(x, y)
    for i in [0..@accuracy]
      x = rEP + (rTS - rEP) * i/@accuracy
      y = - F3 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c3 * @y(x) - c3
      pushPair(x, y)
    for i in [0..@accuracy]
      x = rTS + (1 - rTS) * i/@accuracy
      y = - F4 * @innerChord() * ((1 - @taper())/(3*@span()) * Math.pow(@y(x), 3) - 1/2 * Math.pow(@y(x), 2)) - _c4 * @y(x) - c4
      pushPair(x, y)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: @interpolationTension
    }

  T_value: @reactive 'T_value', (x) ->
    if 0 <= x <= 1.0
      val = @l(x) * ( @Qa(x) * (@relShearCenter() - @liftPowerPosition() * @loadFactor()) + @Qm(x) * (@relShearCenter() - @wingPowerPosition() * @loadFactor()))
      if !@flight() and x <= @relGearPositionY()
        val += @airplaneMass()/2 * @l(x) * 9.81 * (@relShearCenter() * @loadFactor() - @relGearPositionX())
      if x <= @relEnginePositionY()
        val += @engineMass()/2 * @loadFactor() * 9.81 * @l(x) * (@enginePowerPosition() * @loadFactor() - @relShearCenter())
        val -= @thrust() * @relThrustCenterZ() if @thrust() > 0
      val

  T: @memoize 'T', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    rGP = if @flight() then 0 else @relGearPositionY()
    rEP = @relEnginePositionY()

    unless rGP is 0
      for i in [0..@accuracy]
        x = 0 + rGP * i/@accuracy
        y = @l(x) * ( @Qa(x) * (@relShearCenter() - @liftPowerPosition() * @loadFactor()) + @Qm(x) * (@relShearCenter() - @wingPowerPosition() * @loadFactor()))
        y += @engineMass()/2 * @loadFactor() * 9.81 * @l(x) * (@enginePowerPosition() * @loadFactor() - @relShearCenter())
        y -= @thrust() * @relThrustCenterZ() if @thrust() > 0
        y += @airplaneMass()/2 * @l(x) * 9.81 * (@relShearCenter() * @loadFactor() - @relGearPositionX())
        pushPair(x, y)
    for i in [0..@accuracy]
      x = rGP + (rEP - rGP) * i/@accuracy
      y = @l(x) * ( @Qa(x) * (@relShearCenter() - @liftPowerPosition() * @loadFactor()) + @Qm(x) * (@relShearCenter() - @wingPowerPosition() * @loadFactor()))
      y += @engineMass()/2 * @loadFactor() * 9.81 * @l(x) * (@enginePowerPosition() * @loadFactor() - @relShearCenter())
      y -= @thrust() * @relThrustCenterZ() if @thrust() > 0
      pushPair(x, y)
    for i in [0..@accuracy]
      x = rEP + (1 - rEP) * i/@accuracy
      y = @l(x) * ( @Qa(x) * (@relShearCenter() - @liftPowerPosition() * @loadFactor()) + @Qm(x) * (@relShearCenter() - @wingPowerPosition() * @loadFactor()))
      pushPair(x, y)
    return {
      points: points
      minY: minY
      maxY: maxY
      tension: @interpolationTension
    }
