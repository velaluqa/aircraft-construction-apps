# coding: utf-8
ILR.LiftDistribution ?= {}
ILR.LiftDistribution.Models ?= {}
class ILR.LiftDistribution.Models.Calculator extends ILR.Models.BaseCalculator
  curveGroups: [['gamma', 'gamma_a', 'gamma_b', 'elliptic', 'C_a'], ['C_A'], ['geometry']]

  COF = [
    [ 2.1511 , 0.009 ,  -7.3509 ,  7.3094 ,  -2.3048,  -0.4104  ]
    [ 1.7988 , 0.4009,  -7.887  , 17.856  , -23.375 ,  10.867   ]
    [ 1.53045, 0.2337,  -3.75395,  5.9553 ,  -6.447 ,   2.31195 ]
    [ 1.2621 , 0.0665,   0.3791 , -5.9454 ,  10.481 ,  -6.2431  ]
    [ 1.08715, 0.1467,   4.39155, -16.4117,  20.644 ,  -9.88955 ]
    [ 0.9122 , 0.2209,   8.404  , -26.878 ,  30.807 , -13.536   ]
    [ 0.6533 , 1.3704,   6.9543 , -25.579 ,  29.78  , -13.249   ]
    [ 0.559  , 0.8908,   11.602 , -37.973 ,  44.477 , -19.627   ]
  ]

  accuracy: 50
  interpolationTension: 0.25

  constructor: (options = {}) ->
    super(_.defaults(options, required: ['liftDistribution']))

  minX: @reactive 'minX', -> 0
  maxX: @reactive 'maxX', -> 1.0

  xRange: (func) -> 1.0

  # Streckung
  aspectRatio:     @reactive 'aspectRatio',      -> @liftDistribution.get('aspectRatio')
  # Verwindung
  linearTwist:     @reactive 'linearTwist',    -> @liftDistribution.get('linearTwist')
  linearTwistRad:  @reactive 'linearTwistRad', -> @linearTwist() * Math.PI / 180.0
  # Pfeilung
  sweep:           @reactive 'sweep',            -> @liftDistribution.get('sweep')
  sweepRad:        @reactive 'sqeepRad',         -> @sweep() * Math.PI / 180.0
  # Zuspitzung
  taperRatio:      @reactive 'taperRatio',       -> @liftDistribution.get('taperRatio')
  # C_A
  liftCoefficient: @reactive 'liftCoefficient',  -> @liftDistribution.get('liftCoefficient')
  # M_Reise
  cruisingSpeed:   @reactive 'cruisingSpeed',    -> @liftDistribution.get('cruisingSpeed')
  # Spannweite
  l:               @reactive 'wingSpan',         -> @liftDistribution.get('wingSpan')

  # WING GRAPHIC
  wing:    @memoize 'wing',    -> null
  Phi_VK:  @memoize 'Phi_VK',  -> Math.atan( Math.tan(@sweepRad()) + (1 - @taperRatio()) / (@aspectRatio() * (1 + @taperRatio()))) / Math.PI * 180.0
  dya:     @memoize 'dya',     -> Math.tan(@sweepRad()) * @l();
  yl:      @memoize 'yl',      -> 2 * @l() / @aspectRatio()
  la:      @memoize 'la',      -> 2 * @yl() / (1 / @taperRatio() + 1)
  li:      @memoize 'li',      -> @la() / @taperRatio()

  wingY01: @memoize 'wingY01', -> -1 * (- @yl() / 4 - @dya() / 2)
  wingY02: @memoize 'wingY02', -> -1 * (- @wingY01() + @dya())

  wingX1:  @memoize 'wingX1',  -> 0
  wingY1:  @memoize 'wingY1',  -> - (- @wingY01() - @li()/4)

  wingX2:  @memoize 'wingX2',  -> 1
  wingY2:  @memoize 'wingY2',  -> + (@wingY02() + @la()/4)

  wingX3:  @memoize 'wingX3',  -> 0
  wingY3:  @memoize 'wingY3',  -> - (-@wingY1() + @li())

  wingX4:  @memoize 'wingX4',  -> 1
  wingY4:  @memoize 'wingY4',  -> - (-@wingY2() + @la())

  # DIEDERICH
  M_Prof: @memoize 'M_Prof', -> @cruisingSpeed() * Math.sqrt(Math.cos(@sweepRad()))
  c_a_:   @memoize 'c_a_',   -> 2 * Math.PI / Math.sqrt(1 - Math.pow(@M_Prof(), 2))
  FF:     @memoize 'FF',     -> @aspectRatio() / @c_a_() * 2 * Math.PI / Math.cos(@sweepRad())
  k0: @memoize 'k0', ->
    FF = @FF()
    0.2692 * FF - 0.0387 * Math.pow(FF, 2) + 0.002951 * Math.pow(FF, 3) - 0.0001106 * Math.pow(FF, 4) + 1.559 * Math.pow(10, -6) * Math.pow(FF, 5)
  k1: @memoize 'k1', ->
    F = @FF()
    0.3064 + F * (0.05185 - 0.0014 * F)
  c1: @memoize 'c1', ->
    F = @FF()
    0.003647 + F * (0.05614 - 0.0009842 * F)
  c2: @memoize 'c2', ->
    F = @FF()
    1 + F * (0.002721 * F - 0.1098)
  c3: @memoize 'c3', ->
    F = @FF()
    -0.008265 + F * (0.05493 - 0.001816 * F)

  C_A_:  @memoize 'C_A_',  ->
    @c_a_() * @k0() * Math.cos(@sweepRad())

  Phi_e: @memoize 'Phi_e', ->
    Math.atan(Math.tan(@sweepRad()) / Math.sqrt(1 - Math.pow(@cruisingSpeed(), 2)))

  cof:   @memoize 'cof',   ->
    phi = @Phi_e()
    indices = if   phi < -30 then [0, 1]
    else if -30 <= phi < -15 then [1, 2]
    else if -15 <= phi < 0   then [2, 3]
    else if   0 <= phi < 15  then [3, 4]
    else if  15 <= phi < 30  then [4, 5]
    else if  30 <= phi < 45  then [5, 6]
    else if  45 <= phi       then [6, 7]
    upAndLow = _.zip.apply(_, (COF[i] for i in indices))
    m = ((low - up)/15 for [up, low] in upAndLow)
    n = COF[3] # at 0°
    m[i]*phi + n[i] for i in [0...m.length]

  f: @reactive 'f', (n) ->
    c = @cof()
    c[0] + c[1]*n + c[2]*Math.pow(n,2) + c[3]*Math.pow(n,3) + c[4]*Math.pow(n,4) + c[5]*Math.pow(n,5)

  lm_l: @reactive 'lm_l', (n) ->
    @yl() / (@la() / @taperRatio() * (1 - n * (1 - @taperRatio())))

  l_lm: @reactive 'l_lm', (n) ->
    2 / (1 + @taperRatio()) * (1 - n * (1 - @taperRatio()))

  elliptic_value: @reactive 'elliptic_value', (n) ->
    if 0 <= n <= 1.0
      @liftCoefficient() * 4 / Math.PI * Math.sqrt(1 - Math.pow(n, 2))

  elliptic: @reactive 'elliptic', ->
    points = []
    minY = 0
    maxY = 0
    for i in [0..@accuracy]
      n = i/@accuracy
      y = @elliptic_value(n)
      minY = y if y < minY
      maxY = y if y > maxY
      points.push(n, y)
    return {
      points: points
      tension: @interpolationTension
      minY: minY
      maxY: maxY
    }

  gamma_a_value: @reactive 'gamma_a_', (n) ->
    if 0 <= n <= 1.0
      @c1() * @l_lm(n) + @c2() * 4 * Math.sqrt(1 - Math.pow(n, 2)) / Math.PI + @c3() * @f(n)

  gamma_a: @memoize 'gamma_a', ->
    points = []
    minY = 0
    maxY = 0
    for i in [0..@accuracy]
      n = i/@accuracy
      y = @gamma_a_value(n)
      minY = y if y < minY
      maxY = y if y > maxY
      points.push(n, y)
    return {
      points: points
      tension: @interpolationTension
      minY: minY
      maxY: maxY
    }

  epsylon: @reactive 'epsylon', (n) ->
    @linearTwistRad() * n

  integral: ->
    sum = @gamma_a_value(0) * @epsylon(0)
    for i in [1..@accuracy]
      nPrev = (i-1)/@accuracy
      n = i/@accuracy
      sum += (@gamma_a_value(nPrev)*@epsylon(nPrev) + @gamma_a_value(n)*@epsylon(n))*(1/@accuracy)/2
    sum

  gamma_b_value: @reactive 'gamma_b_value', (n) ->
    if 0 <= n <= 1.0
      @k1() * @C_A_() * @gamma_a_value(n) * (@epsylon(n) - @integral())

  gamma_b: @memoize 'gamma_b', ->
    points = []
    minY = Infinity
    maxY = -Infinity
    for i in [0..@accuracy]
      n = i/@accuracy
      y = @gamma_b_value(n)
      minY = y if y < minY
      maxY = y if y > maxY
      points.push(n, y)
    return {
      points: points
      tension: @interpolationTension
      minY: minY
      maxY: maxY
    }

  gamma_value: @reactive 'gamma_value', (n) ->
    if 0 <= n <= 1.0
      @gamma_a_value(n) * @liftCoefficient() + @gamma_b_value(n)

  gamma: @reactive 'gamma', (n) ->
    pointsA = @gamma_a().points
    pointsB = @gamma_b().points
    minY = Infinity
    maxY = -Infinity
    points = []
    for i in [0..pointsA.length-1] by 2
      n = pointsA[i]
      y = pointsA[i+1] * @liftCoefficient() + pointsB[i+1]
      minY = y if y < minY
      maxY = y if y > maxY
      points.push(n, y)
    return {
      points: points
      tension: @interpolationTension
      minY: minY
      maxY: maxY
    }

  C_a_value: @reactive 'C_a_value', (n) ->
    if 0 <= n <= 1.0
      @gamma_value(n) * @lm_l(n)

  C_a: @memoize 'C_a', ->
    gammaPoints = @gamma().points
    minY = Infinity
    maxY = -Infinity
    points = []
    for i in [0..gammaPoints.length-1] by 2
      n = gammaPoints[i]
      y = gammaPoints[i+1] * @lm_l(n)
      minY = y if y < minY
      maxY = y if y > maxY
      points.push(n, y)
    return {
      points: points
      tension: @interpolationTension
      minY: minY
      maxY: maxY
    }

  C_A_value: @reactive 'C_A_value', (n) ->
    @C_A_() if 0 <= n <= 1.0

  C_A: @memoize 'C_A', ->
    val = @C_A_()
    return {
      points: [@minX(), val, @maxX(), val]
      tension: 0
      minY: val
      maxY: val
    }

  geometry_value: @reactive 'geometry_value', (n) -> 0
  geometry: @memoize 'geometry', ->
    return {
      points: [@wingX1(), @wingY1(), @wingX2(), @wingY2(), @wingX4(), @wingY4(), @wingX3(), @wingY3()]
      tension: 0
      minY: -50
      maxY: 50
    }
