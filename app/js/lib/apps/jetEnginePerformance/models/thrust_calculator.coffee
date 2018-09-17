ILR.JetEnginePerformance ?= {}
ILR.JetEnginePerformance.Models ?= {}
class ILR.JetEnginePerformance.Models.ThrustCalculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['thrustApp']))

  accuracy: 20
  interpolationTension: 0.25

  height: @reactive 'height', ->  @thrustApp.get('height')
  mu:     @reactive 'mu',     -> @thrustApp.get('mu')
  deltaP: @reactive 'deltaP', -> @thrustApp.get('deltaP')
  D:      @reactive 'D',      -> @thrustApp.get('D')

  yRange: -> 1.0

  # dT / dH
  A:   -> -0.0065
  # Groundtemperature
  t0:  -> 288.15
  # Gravitational Acceleration
  g0:  -> 9.80665
  # Universal Gas Constant
  R:   -> 287.05287
  # T11 = @t0() + @A() * 11000
  T11: -> 216.65

  t: @memoize 't', ->
    h = @height()
    if h >= 11
      @t0() - 6.5 * 11
    else
      @t0() - 6.5 * h

  p_p0: @memoize 'p_p0', ->
    h = @height()
    Math.pow(1 + @A() * h * 1000 / @t0(), - @g0()/ (@A() * @R()))

  rho_rho0: @memoize 'rho_rho0', ->
    @t0() * @p_p0()/@t()

  SS0: @reactive 'SS0', (br, x) ->
    eta_intake = 1 - (1.3 + 0.25 * br) * @deltaP()
    @D() * @rho_rho0() * Math.exp(- 0.35 * x * @p_p0() * Math.sqrt(br)) * eta_intake

  SS_value: @reactive 'SS_value', (x) ->
    br = @mu()
    @SS0(br, x)

  SS: @memoize 'SS', ->
    bypassRatio = @mu()
    minY = null
    maxY = null
    points = []
    for i in [0..@accuracy]
      x = Math.round(i/@accuracy * 100)/100
      y = @SS0(bypassRatio, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  SS_m0_value: @reactive 'SS_m0_value', (x) -> @SS0(0, x)
  SS_m0: @memoize 'SS_m0', ->
    bypassRatio = 0
    minY = null
    maxY = null
    points = []
    for i in [0..@accuracy]
      x = Math.round(i/@accuracy * 100)/100
      y = @SS0(bypassRatio, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  SS_m2_value: @reactive 'SS_m2_value', (x) -> @SS0(2, x)
  SS_m2: @memoize 'SS_m2', ->
    bypassRatio = 2
    minY = null
    maxY = null
    points = []
    for i in [0..@accuracy]
      x = Math.round(i/@accuracy * 100)/100
      y = @SS0(bypassRatio, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  SS_m4_value: @reactive 'SS_m4_value', (x) -> @SS0(4, x)
  SS_m4: @memoize 'SS_m4', ->
    bypassRatio = 4
    minY = null
    maxY = null
    points = []
    for i in [0..@accuracy]
      x = Math.round(i/@accuracy * 100)/100
      y = @SS0(bypassRatio, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  SS_m6_value: @reactive 'SS_m6_value', (x) -> @SS0(6, x)
  SS_m6: @memoize 'SS_m6', ->
    bypassRatio = 6
    minY = null
    maxY = null
    points = []
    for i in [0..@accuracy]
      x = Math.round(i/@accuracy * 100)/100
      y = @SS0(bypassRatio, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  SS_m8_value: @reactive 'SS_m8_value', (x) -> @SS0(8, x)
  SS_m8: @memoize 'SS_m8', ->
    bypassRatio = 8
    minY = null
    maxY = null
    points = []
    for i in [0..@accuracy]
      x = Math.round(i/@accuracy * 100)/100
      y = @SS0(bypassRatio, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }

  SS_m10_value: @reactive 'SS_m10_value', (x) -> @SS0(10, x)
  SS_m10: @memoize 'SS_m10', ->
    bypassRatio = 10
    minY = null
    maxY = null
    points = []
    for i in [0..@accuracy]
      x = Math.round(i/@accuracy * 100)/100
      y = @SS0(bypassRatio, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: 0
    }
