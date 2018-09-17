ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Models ?= {}
class ILR.AirplaneInternalLoads.Models.FuselageCalculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  interpolationTension: 0.2
  accuracy: 10

  loadCase:                   @reactive 'loadCase',                   -> @model.get('loadCase')
  fuselageMass:               @reactive 'fuselageMass',               -> @model.get('fuselageMass')
  fuselageLength:             @reactive 'fuselageLength',             -> @model.get('fuselageLength')
  relFirstMainFramePosition:  @reactive 'relFirstMainFramePosition',  -> @model.get('relFirstMainFramePosition')/100
  relSecondMainFramePosition: @reactive 'relSecondMainFramePosition', -> @model.get('relSecondMainFramePosition')/100
  relGearPosition:            @reactive 'relGearPosition',            -> @model.get('relGearPosition')/100
  stabilizerLoad:             @reactive 'stabilizerLoad',             -> @model.get('stabilizerLoad')

  flight: @reactive 'flight', ->
    @loadCase() is 'flight'

  load: @memoize 'load', ->
    - @fuselageMass() / @fuselageLength() * 9.81

  loadA: @memoize 'loadA', ->
    boundary = if @flight() then @relFirstMainFramePosition() else @relGearPosition()
    (@stabilizerLoad() * (@relSecondMainFramePosition() - 1) + @load() * @fuselageLength() * (@relSecondMainFramePosition() - 0.5)) / (boundary - @relSecondMainFramePosition())

  loadB: @memoize 'loadB', ->
    - @load() * @fuselageLength() - @loadA() - @stabilizerLoad()

  l: @reactive 'l', (x) ->
    @fuselageLength() * x

  Q_value: @reactive 'Q_value', (x) ->
    boundary = if @flight() then @relFirstMainFramePosition() else @relGearPosition()
    if 0 <= x < boundary
      @load() * @l(x)
    else if boundary <= x < @relSecondMainFramePosition()
      @load() * @l(x) + @loadA()
    else if @relSecondMainFramePosition() <= x <= 1.0
      @load() * @l(x) + @loadA() + @loadB()

  Q: @memoize 'Q', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    boundary    = if @flight() then @relFirstMainFramePosition() else @relGearPosition()
    for x in [0, boundary]
      pushPair(x, @load() * @l(x))
    for x in [boundary, @relSecondMainFramePosition()]
      pushPair(x, @load() * @l(x) + @loadA())
    for x in [@relSecondMainFramePosition(), 1]
      pushPair(x, @load() * @l(x) + @loadA() + @loadB())

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  M_value: @reactive 'M_value', (x) ->
    boundary = if @flight() then @relFirstMainFramePosition() else @relGearPosition()
    if 0 <= x < boundary
      @load() * 0.5 * Math.pow(@l(x), 2)
    else if boundary <= x < @relSecondMainFramePosition()
      @load() * 0.5 * Math.pow(@l(x), 2) + @loadA() * @l(x - boundary)
    else if @relSecondMainFramePosition() <= x <= 1.0
      @load() * 0.5 * Math.pow(@l(x), 2) + @loadA() * @l(x - boundary) + @loadB() * @l(x - @relSecondMainFramePosition())

  M: @memoize 'M', ->
    minY = null
    maxY = null
    points = [[],[],[]]
    pushPair = (part, x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points[part].push(x, y)

    boundary = if @flight() then @relFirstMainFramePosition() else @relGearPosition()
    for i in [0..@accuracy]
      x = 0 + boundary * i/@accuracy
      y = @load() * 0.5 * Math.pow(@l(x), 2)
      pushPair(0, x, y)
    for i in [0..@accuracy]
      x = boundary + (@relSecondMainFramePosition() - boundary) * i/@accuracy
      y = @load() * 0.5 * Math.pow(@l(x), 2) + @loadA() * @l(x - boundary)
      pushPair(1, x, y)
    for i in [0..@accuracy]
      x = @relSecondMainFramePosition() + (1.0 - @relSecondMainFramePosition()) * i/@accuracy
      y = @load() * 0.5 * Math.pow(@l(x), 2) + @loadA() * @l(x - boundary) + @loadB() * @l(x - @relSecondMainFramePosition())
      pushPair(2, x, y)

    res = {
      points: points
      minY: minY
      maxY: maxY
      tension: @interpolationTension
      multiplePaths: true
    }
    res
