ILR.VnDiagram ?= {}
ILR.VnDiagram.Models ?= {}
class ILR.VnDiagram.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  interpolationTension: 0.5
  accuracy: 50

  xRange: @reactive 'xRange', -> @vD()
  yRange: -> 4

  vdvc60:                    @reactive 'vdvc60',                    -> @model.get('vdvc60')
  designSpeed:               @reactive 'designSpeed',               -> @model.get('designSpeed')
  aspectRatio:               @reactive 'aspectRatio',               -> @model.get('aspectRatio')
  taperRatio:                @reactive 'taperRatio',                -> @model.get('taperRatio')
  takeOffMass:               @reactive 'takeOffMass',               -> @model.get('takeOffMass')
  maxSurfaceLoad:            @reactive 'maxSurfaceLoad',            -> @model.get('maxSurfaceLoad')
  fuelFactor:                @reactive 'fuelFactor',                -> @model.get('fuelFactor')
  wingSweep:                 @reactive 'wingSweep',                 -> @model.get('wingSweep')
  maxLiftCoefficient:        @reactive 'maxLiftCoefficient',        -> @model.get('maxLiftCoefficient')
  minLiftCoefficient:        @reactive 'minLiftCoefficient',        -> @model.get('minLiftCoefficient')
  maxStartLiftCoefficient:   @reactive 'maxStartLiftCoefficient',   -> @model.get('maxStartLiftCoefficient')
  maxLandingLiftCoefficient: @reactive 'maxLandingLiftCoefficient', -> @model.get('maxLandingLiftCoefficient')
  altitude:                  @reactive 'altitude',                  -> @model.get('altitude')

  rho0: 0.125
  g: 9.81

  planeMassRatio: @reactive 'planeMassRatio', ->
    wingArea = @takeOffMass() * 1000 / @maxSurfaceLoad()
    refWingDepth = Math.sqrt(wingArea / @aspectRatio())
    2 * @maxSurfaceLoad() / @rho0 / @g / @liftIncrease() / refWingDepth

  blastReductionRatio: @reactive 'blastReductionRatio', ->
    planeMassRatio = @planeMassRatio()
    0.88 * planeMassRatio / (5.3 + planeMassRatio)

  # TODO: Write test for maxLiftCoefficient = 0
  # TODO: Write test for maxLoadFactor = max or min
  vA: @reactive 'vA', ->
    Math.sqrt(@maxLoadFactor() * @maxSurfaceLoad() * 2 / @rho0 / @maxLiftCoefficient())

  # TODO: Write test for maxSurfaceLoad = 0
  # TODO: Write test for maxLiftCoefficient = 0
  vB: @reactive 'vB', ->
    a = 2 / @maxLiftCoefficient() / @rho0 / @maxSurfaceLoad()
    b = - @blastReductionRatio() * @uB() * @liftIncrease() * 2 / @rho0 / @maxSurfaceLoad()
    c = -1
    - b / 2 / a + Math.sqrt(b ** 2 - 4 * a * c) / 2 / a

  vC: @reactive 'vC', -> @designSpeed()

  vH: @reactive 'vH', ->
    Math.sqrt(- @maxSurfaceLoad() * 2 / @rho0 / @minLiftCoefficient())

  vD: @reactive 'vD', ->
    return @vC() * 1.25 if @vC() * 3.6 < 400
    if @vdvc60() is 'yes'
      @vC() + 60 * 1.852 / 3.6
    else
      @vC() * 2.38 * @vC() ** -0.11

  vStall: @reactive 'vStall', ->
    Math.sqrt(2 * @maxSurfaceLoad() / @maxLiftCoefficient() / @rho0)

  maxLoadFactor: @memoize 'maxLoadFactor', ->
    return 3.8 if @takeOffMass() < 1.754
    return 2.5 if @takeOffMass() > 22.71
    2.1 + 10700 / (4540 + @takeOffMass() * 1000)

  minLoadFactor: -> -1

  _altitudeLimit: (speed) ->
    if speed > 295
      -288.16 * ((@designSpeed() / 340) ** 2 - 1) / 6.5

  _designSpeedLimit: (altitude) ->
    if altitude > 11
      295
    else
      Math.sqrt((288.16 - 6.5 * altitude) / 288.16) * 340

  liftIncrease: @reactive 'liftIncrease', ->
    a = if @altitude() > 11
      295
    else
      Math.sqrt((288.16 - 6.5 * @altitude()) / 288.16) * 340
    Ma = @vC() / a
    pg = Math.sqrt(1 - Ma ** 2)
    phi50 = Math.atan(Math.tan(@wingSweep() / 57.3) - (1 - @taperRatio()) / (@aspectRatio() * (1 + @taperRatio()))) * 57.3
    Math.PI * @aspectRatio() / (1 + Math.sqrt(1 + (@aspectRatio() / 2) ** 2 * (Math.tan(phi50 / 57.3) ** 2 + pg ** 2)))

  # Min. speed without Tab in [m/s]
  vFS: @reactive 'vFS', ->
    Math.sqrt(4 * @maxSurfaceLoad() / @rho0 / @maxStartLiftCoefficient())

  vFCS: @reactive 'vFCS', ->
    1.6 * @vFS()

  landingSurfaceLoad: @reactive 'landingSurfaceLoad', ->
    @maxSurfaceLoad() * (1 - @fuelFactor() / 2)

  vFL: @reactive 'vFL', ->
    Math.sqrt(4 * @landingSurfaceLoad() / @rho0 / @maxLandingLiftCoefficient())

  vFCL: @reactive 'vFCL', ->
    1.8 * @vFL()

  uB: @reactive 'uB', ->
    return 20.1168 if @altitude() < 6.096
    20.1168 + (20.1168 - 11.6) / (6.096 - 15.24) * (@altitude() - 6.096)

  uC: @reactive 'uC', ->
    return 15.24 if @altitude() <  6.096
    15.24 + (15.24 - 7.62) / (6.096 - 15.24) * (@altitude() - 6.096)

  uD: @reactive 'uD', ->
    return 7.62 if @altitude() < 6.096
    7.62 + (7.62 - 3.81) / (6.096 - 15.24) * (@altitude() - 6.096)

  nFTS_value: @reactive 'nFTS_value', (x) ->
    if 0 <= x < @vFS()
      @maxStartLiftCoefficient() * @rho0 / 2 / @maxSurfaceLoad() * (x ** 2)
    else if @vFS() <= x <= @vFCS()
      2

  nFTS: @memoize 'nFTS', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    for x in [0..@vFS()] by @vFS() / @accuracy
      pushPair(x, @maxStartLiftCoefficient() * @rho0 / 2 / @maxSurfaceLoad() * (x ** 2))
    pushPair(@vFS(), 2)
    pushPair(@vFCS(), 2)
    pushPair(@vFCS(), 0)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  nFTL_value: @reactive 'nTFL_value', (x) ->
    if 0 <= x < @vFL()
      @maxLandingLiftCoefficient() * @rho0 / 2 / @landingSurfaceLoad() * (x ** 2)
    else if @vFL() <= x <= @vFCL()
      2

  nFTL: @memoize 'nFTL', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    for x in [0..@vFL()] by @vFL() / @accuracy
      pushPair(x, @nFTL_value(x))
    pushPair(@vFL(), 2)
    pushPair(@vFCL(), 2)
    pushPair(@vFCL(), 0)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  nFmax_value: @reactive 'nFmax_value', (x) ->
    if 0 <= x < @vA()
      val = @maxLiftCoefficient() * @rho0 / 2 / @maxSurfaceLoad() * x ** 2
      Math.min(val, 3.8)
    else if @vA() <= x < Math.ceil(@vD())
      @maxLoadFactor()

  nFmax: @memoize 'nFmax', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    for x in [0..@vA()] by @vA() / @accuracy
      pushPair(x, @nFmax_value(x))
    pushPair(@vA(), @maxLoadFactor())
    pushPair(@vD(), @maxLoadFactor())
    pushPair(@vD(), 0)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  nFmin_value: @reactive 'nFmin_value', (x) ->
    if 0 <= x < @vH()
      @minLiftCoefficient() * @rho0 / 2 / @maxSurfaceLoad() * x ** 2
    else if @vH() <= x < @vC()
      @minLoadFactor()
    else if @vC() <= x <= @vD()
      -1 + (x - @vC()) / (@vD() - @vC())

  nFmin: @memoize 'nFmin', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    for x in [0..@vH()] by @vH() / @accuracy
      pushPair(x, @minLiftCoefficient() * @rho0 / 2 / @maxSurfaceLoad() * x ** 2)
    pushPair(@vH(), @minLoadFactor())
    pushPair(@vC(), @minLoadFactor())
    pushPair(@vD(), 0)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  nF_value: @reactive 'nF_value', (x) ->
    [@nFmin_value(x), @nFmax_value(x)]

  nF: @memoize 'nF', ->
    max = @nFmax()
    min = @nFmin()

    return {
      max: { points: max.points }
      min: { points: min.points }
      minY: Math.min(max.minY, min.minY)
      maxY: Math.max(max.maxY, min.maxY)
    }

  nGmax_value: @reactive 'nGmax_value', (x) ->
    return if x > @vD()
    if x >= @vC()
      fC = 1 + @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad()
      fD = 1 + @rho0 * @blastReductionRatio() * @uD() * @liftIncrease() * @vD() / 2 / @maxSurfaceLoad()
      (fD - fC) / (@vD() - @vC()) * (x - @vC()) + fC
    else if x >= @vB()
      fB = @rho0 * @maxLiftCoefficient() / 2 / @maxSurfaceLoad() * @vB() ** 2
      fC = 1 + @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad()
      (fC - fB) / (@vC() - @vB()) * (x - @vB()) + fB
    else if x >= @nGmin_limit()
      @rho0 * @maxLiftCoefficient() / 2 / @maxSurfaceLoad() * x ** 2

  nGmax: @memoize 'nGmax', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    for x in [@nGmin_limit()..@vB()] by @vB() / @accuracy
      pushPair(x, @nGmax_value(x))
    pushPair(@vB(), @nGmax_value(@vB()))
    pushPair(@vC(), 1 + @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad())
    pushPair(@vD(), 1 + @rho0 * @blastReductionRatio() * @uD() * @liftIncrease() * @vD() / 2 / @maxSurfaceLoad())
    pushPair(@vD(), 0)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  # We need a `_nGmin_value` as wrapper because the actual `nGmin_value` is
  # limited by `nGmin_limit` which itself uses `_nGmin_value` for
  # calculating the limit.
  _nGmin_value: @reactive '_nGmin_value', (x) ->
    if 0 <= x < @vB()
      1 - @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() * x / 2 / @maxSurfaceLoad()
    else if @vB() <= x < @vC()
      fB = 1 - @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() * @vB() / 2 / @maxSurfaceLoad()
      fC = 1 - @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad()
      (fC - fB) / (@vC() - @vB()) * (x - @vB()) + fB
    else if @vC() <= x <= @vD()
      fC = 1 - @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad()
      fD = 1 - @rho0 * @blastReductionRatio() * @uD() * @liftIncrease() * @vD() / 2 / @maxSurfaceLoad()
      (fD - fC) / (@vD() - @vC()) * (x - @vC()) + fC


  nGmin_limit: @reactive 'nGmin_limit', ->
    vB = @vB()
    vC = @vC()
    if @nGmax_value(vB) > @_nGmin_value(vB)
      factor1 = @rho0 * @maxLiftCoefficient() / 2 / @maxSurfaceLoad()
      factor2 = @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() / 2 / @maxSurfaceLoad()
      p = factor2 / factor1
      q = -1 / factor1
      x1 = -p / 2 + Math.sqrt((p / 2) ** 2 - q)
      x2 = -p / 2 - Math.sqrt((p / 2) ** 2 - q)
      return x1 if 0 <= x1 <= vB
      return x2 if 0 <= x2 <= vB

    else if @nGmax_value(vB) <= @_nGmin_value(vB)
      fB1 = @rho0 * @maxLiftCoefficient() / 2 / @maxSurfaceLoad() * @vB() ** 2
      fC1 = 1 + @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad()
      f1 = (fC1 - fB1) / (@vC() - @vB())

      fB2 = 1 - @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() * @vB() / 2 / @maxSurfaceLoad()
      fC2 = 1 - @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad()
      f2 = (fC2 - fB2) / (@vC() - @vB())

      (fB2 - fB1) / (f1 - f2) + vB

  nGmin_value: @reactive 'nGmin_value', (x) ->
    limit = @nGmin_limit()
    @_nGmin_value(x) if limit <= x

  nGmin: @memoize 'nGmin', ->
    minY = null
    maxY = null
    points = []
    pushPair = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    limit = @nGmin_limit()
    pushPair(limit, @_nGmin_value(limit))
    if limit < @vB()
      pushPair(@vB(), 1 - @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() * @vB() / 2 / @maxSurfaceLoad())
    pushPair(@vC(), 1 - @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad())
    pushPair(@vD(), 1 - @rho0 * @blastReductionRatio() * @uD() * @liftIncrease() * @vD() / 2 / @maxSurfaceLoad())
    pushPair(@vD(), 0)

    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  nG_value: @reactive 'nG_value', (x) ->
    [@nGmin_value(x), @nGmax_value(x)]

  nG: @memoize 'nG', ->
    max = @nGmax()
    min = @nGmin()

    return {
      max: { points: max.points }
      min: { points: min.points }
      minY: Math.min(max.minY, min.minY)
      maxY: Math.max(max.maxY, min.maxY)
    }

  gustLines: @memoize 'gustLines', ->
    gustLineB = { points: [0, 1] }
    gustLineC = { points: [0, 1] }
    gustLineD = { points: [0, 1] }
    gustLineE = { points: [0, 1] }
    gustLineF = { points: [0, 1] }
    gustLineG = { points: [0, 1] }

    gustLineB.points.push(@vB(), @nGmax_value(@vB()))
    gustLineC.points.push(@vC(), 1 + @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad())
    gustLineD.points.push(@vD(), 1 + @rho0 * @blastReductionRatio() * @uD() * @liftIncrease() * @vD() / 2 / @maxSurfaceLoad())
    gustLineE.points.push(@vD(), 1 - @rho0 * @blastReductionRatio() * @uD() * @liftIncrease() * @vD() / 2 / @maxSurfaceLoad())
    gustLineF.points.push(@vC(), 1 - @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad())
    gustLineG.points.push(@vB(), 1 - @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() * @vB() / 2 / @maxSurfaceLoad())

    return {
      gustLineB: gustLineB
      gustLineC: gustLineC
      gustLineD: gustLineD
      gustLineE: gustLineE
      gustLineF: gustLineF
      gustLineG: gustLineG
    }

  speedAnnotations: @memoize 'speedAnnotations', ->
    # This is a dummy for the custom graph renderer...
    return {}

  gustHull: @memoize 'gustHull', ->
    # limit nGmin at the x-Axis
    nGmin = []
    if @nGmin_value(@vB()) < 0
      factor = - @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() / 2 / @maxSurfaceLoad()
      x = - 1 / factor
      nGmin.push(x, 0)
      nGmin.push(@vB(), @nGmin_value(@vB()))
    else
      fB = 1 - @rho0 * @blastReductionRatio() * @uB() * @liftIncrease() * @vB() / 2 / @maxSurfaceLoad()
      fC = 1 - @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad()
      factor = (fC - fB) / (@vC() - @vB())
      x = @vB() - fB / factor
      nGmin.push(x, 0)
    nGmin.push(@vC(), 1 - @rho0 * @blastReductionRatio() * @uC() * @liftIncrease() * @vC() / 2 / @maxSurfaceLoad())
    nGmin.push(@vD(), 1 - @rho0 * @blastReductionRatio() * @uD() * @liftIncrease() * @vD() / 2 / @maxSurfaceLoad())

    return {
      nFmax: @nFmax().points
      nFmin: @nFmin().points
      nGmax: @nGmax().points
      nGmin: nGmin
    }
