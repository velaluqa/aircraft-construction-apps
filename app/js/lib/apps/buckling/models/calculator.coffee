ILR.Buckling ?= {}
ILR.Buckling.Models ?= {}
class ILR.Buckling.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  yRange: (func) -> 50
  xRange: (func) -> 9

  accuracy: 200

  stiffenings: @reactive 'stiffenings', -> @model.get('stiffenings')
  yx_ratio:    @reactive 'yx_ratio',    -> @model.get('yx_ratio')

  _bucklingValue: @reactive '_bucklingValue', (m, r) ->
    q = m / r
    q2 = q * q
    bucklings = @stiffenings() + 1
    bucklings2 = bucklings * bucklings
    i = q2 + bucklings2
    i * i / (q2 + @yx_ratio() * bucklings2)

  bucklingValueCurve: @reactive 'bucklingValueCurve', (m) ->
    points = []
    stepSize = (9 - 0.1) / @accuracy
    if (k = @yx_ratio()) < 0
      bucklings = @stiffenings() + 1
      max = m / Math.sqrt(-k*bucklings*bucklings) - 0.01 # skip behind discontinuty
    else
      max = @xIntersection(6) + 1
    max = 20 if isNaN(max)
    for r in [0.1..max] by stepSize
      val = @_bucklingValue(m, r)
      points.push r, val if val < 1000
    return {
      points: points
      tension: 0.5
    }

  bucklingValue_1: @memoize 'bucklingValue_1', -> @bucklingValueCurve(1)
  bucklingValue_2: @memoize 'bucklingValue_2', -> @bucklingValueCurve(2)
  bucklingValue_3: @memoize 'bucklingValue_3', -> @bucklingValueCurve(3)
  bucklingValue_4: @memoize 'bucklingValue_4', -> @bucklingValueCurve(4)
  bucklingValue_5: @memoize 'bucklingValue_5', -> @bucklingValueCurve(5)
  bucklingValue_6: @memoize 'bucklingValue_6', -> @bucklingValueCurve(6)

  bucklingValue_1_value: @reactive 'bucklingValue_1_value', (r) -> @_bucklingValue(1, r)
  bucklingValue_2_value: @reactive 'bucklingValue_2_value', (r) -> @_bucklingValue(2, r)
  bucklingValue_3_value: @reactive 'bucklingValue_3_value', (r) -> @_bucklingValue(3, r)
  bucklingValue_4_value: @reactive 'bucklingValue_4_value', (r) -> @_bucklingValue(4, r)
  bucklingValue_5_value: @reactive 'bucklingValue_5_value', (r) -> @_bucklingValue(5, r)
  bucklingValue_6_value: @reactive 'bucklingValue_6_value', (r) -> @_bucklingValue(6, r)

  festoon: @memoize 'festoon', ->
    points = []

    xLowerBound = 0
    for m, m_idx in ([1..6])
      points[m_idx] = []
      m_points = @bucklingValueCurve(m).points
      xUpperBound = @xIntersection(m)
      if isNaN(xUpperBound)
        points = [m_points]
        break
      p_idx = 0
      while p_idx < m_points.length-1 and m_points[p_idx] <= xLowerBound
        p_idx += 2
      if m > 1
        y = @_bucklingValue(m, xLowerBound)
        points[m_idx].push(xLowerBound, y)
        points[m_idx-1].push(xLowerBound, y)
      while p_idx < m_points.length-1 and m_points[p_idx] < xUpperBound
        points[m_idx].push(m_points[p_idx], m_points[p_idx+1])
        p_idx += 2
      xLowerBound = xUpperBound

    return {
      points: points
      multiplePaths: true
      tension: 0.5
    }

  xIntersection: @memoize 'xIntersection', (m) ->
    n = @model.get('stiffenings') + 1
    k = @model.get('yx_ratio')
    m2 = m * m
    mp12 = (m+1)*(m+1)
    Math.sqrt((-k*(m2+m+0.5)-Math.sqrt(k*k*(m2+mp12)*(m2+mp12)-8*(k-0.5)*m2*mp12)/2)/(2*k-1))/n

  xMin: @memoize 'xMin', (m) ->
    n = @model.get('stiffenings') + 1
    k = @model.get('yx_ratio')
    n2 = n * n
    m/Math.sqrt(n2 - 2 * n2 * k)
