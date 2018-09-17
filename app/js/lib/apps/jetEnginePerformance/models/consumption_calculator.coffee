ILR.JetEnginePerformance ?= {}
ILR.JetEnginePerformance.Models ?= {}
class ILR.JetEnginePerformance.Models.ConsumptionCalculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['consumptionApp']))

  accuracy: 20
  interpolationTension: 0.25

  mu:     @reactive 'mu',     -> @consumptionApp.get('mu')
  height: @reactive 'height', -> @consumptionApp.get('height')
  # delta / p
  deltaP: @reactive 'deltaP', -> @consumptionApp.get('deltaP')
  # Turbine Entry Temperature
  TET:    @reactive 'TET',    -> @consumptionApp.get('TET')
  # Over-All Preasure Ratio
  OAPR:   @reactive 'OAPR',   -> @consumptionApp.get('OAPR')
  # Verdichterwirkungsgrad
  eta_c:  @reactive 'eta_c',  -> @consumptionApp.get('eta_c')
  # Fanwirkungsgrad
  eta_f:  @reactive 'eta_f',  -> @consumptionApp.get('eta_f')
  # Düsenwirkungsgrad
  eta_n : @reactive 'eta_n',  -> @consumptionApp.get('eta_n')
  # Turninenwirkungsgrad
  eta_t:  @reactive 'eta_t',  -> @consumptionApp.get('eta_t')

  yRange: -> 1.0

  # Isentropic Exponent
  gamma: 1.4
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

  # Temperature at `@height()`.
  t: @memoize 't', ->
    h = @height()
    if h >= 11
      @t0() - 6.5 * 11
    else
      @t0() - 6.5 * h

  # Dimensionless Representation of the Turbine Inlet Temperature
  phi: @reactive 'phi', ->
    @TET() / @t()

  # Einlaufwirkungsgrad
  eta_intake: @reactive 'eta_intake', (bypass) ->
    1 - (1.3 + 0.25 * bypass)* @deltaP()

  teta: @reactive 'teta', (x) ->
    1 + (@gamma - 1) / 2 * x * x

  kappa: @reactive 'kappa', (x) ->
    @teta(x) * (Math.pow(@OAPR(), (@gamma - 1)/@gamma) - 1)

  eta_i: @reactive 'eta_i', (bypass, x) ->
    1 - (0.7 * x * x * (1 - @eta_intake(bypass))) / (1 + 0.2 * x * x)

  G: @reactive 'G', (bypass, x) ->
    (@phi() - @kappa(x)/@eta_c()) * (1 - 1.01/(Math.pow(@eta_i(bypass, x), (@gamma-1)/@gamma) * (@kappa(x) + @teta(x)) * (1 - @kappa(x)/(@phi()*@eta_c()*@eta_t()))))

  _SFC: @reactive '_SFC', (bypass, x) ->
    0.697 * Math.sqrt(@t()/@t0()) * (@phi() - @teta(x) - @kappa(x)/@eta_c()) / (Math.sqrt(5*@eta_n()*(1 + @eta_f() * @eta_t() * bypass) * (@G(bypass, x) + 0.2 * x * x * bypass * @eta_intake(bypass)/(@eta_f() * @eta_t()))) - x * (1 + bypass))

  SFC_unlimited: (x) -> @_SFC(@mu(), x)
  SFC_value: @reactive 'SFC_value', (x) ->
    @_SFC(@mu(), x) if 0 <= x <= @pole('SFC_unlimited')
  SFC: @memoize 'SFC', ->
    bypass = @mu()
    minY = null
    maxY = null
    points = []
    pole = @pole('SFC_unlimited')
    for i in [0..@accuracy]
      x = i/@accuracy * pole
      y = @_SFC(@mu(), x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: @interpolationTension
    }

  SFC_m0_unlimited: (x) -> @_SFC(0, x)
  SFC_m0_value: (x) -> @_SFC(0, x) if 0 <= x <= @pole('SFC_m0_unlimited')
  SFC_m0: @memoize 'SFC_m0', ->
    minY = null
    maxY = null
    points = []
    pole = @pole('SFC_m0_unlimited')
    for i in [0..@accuracy]
      x = i/@accuracy *
      y = @_SFC(0, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: @interpolationTension
    }

  SFC_m2_unlimited: (x) -> @_SFC(2, x)
  SFC_m2_value: (x) -> @_SFC(2, x) if 0 <= x <= @pole('SFC_m2_unlimited')
  SFC_m2: @memoize 'SFC_m2', ->
    minY = null
    maxY = null
    points = []
    pole = @pole('SFC_m2_unlimited')
    for i in [0..@accuracy]
      x = i/@accuracy * pole
      y = @_SFC(2, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: @interpolationTension
    }

  SFC_m4_unlimited: (x) -> @_SFC(4, x)
  SFC_m4_value: (x) -> @_SFC(4, x) if 0 <= x <= @pole('SFC_m4_unlimited')
  SFC_m4: @memoize 'SFC_m4', ->
    minY = null
    maxY = null
    points = []
    pole = @pole('SFC_m4_unlimited')
    for i in [0..@accuracy]
      x = i/@accuracy * pole
      y = @_SFC(4, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: @interpolationTension
    }

  SFC_m6_unlimited: (x) -> @_SFC(6, x)
  SFC_m6_value: (x) -> @_SFC(6, x) if 0 <= x <= @pole('SFC_m6_unlimited')
  SFC_m6: @memoize 'SFC_m6', ->
    minY = null
    maxY = null
    points = []
    pole = @pole('SFC_m6_unlimited')
    for i in [0..@accuracy]
      x = i/@accuracy * pole
      y = @_SFC(6, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: @interpolationTension
    }

  SFC_m8_unlimited: (x) -> @_SFC(8, x)
  SFC_m8_value: (x) -> @_SFC(8, x) if 0 <= x <= @pole('SFC_m8_unlimited')
  SFC_m8: @memoize 'SFC_m8', ->
    minY = null
    maxY = null
    points = []
    pole = @pole('SFC_m8_unlimited')
    for i in [0..@accuracy]
      x = i/@accuracy * pole
      y = @_SFC(8, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: @interpolationTension
    }

  SFC_m10_unlimited: (x) -> @_SFC(10, x)
  SFC_m10_value: (x) -> @_SFC(10, x) if 0 <= x <= @pole('SFC_m10_unlimited')
  SFC_m10: @memoize 'SFC_m10', ->
    minY = null
    maxY = null
    points = []
    pole = @pole('SFC_m10_unlimited')
    for i in [0..@accuracy]
      x = i/@accuracy * pole
      y = @_SFC(10, x)
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x,y)
    return {
      points: points
      maxY: maxY
      minY: minY
      tension: @interpolationTension
    }
