ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.StaticMomentCalculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  accuracy: 10

  yRange: -> (Math.abs(@za()) + Math.abs(@l()))
  xRange: -> (Math.abs(@za()) + Math.abs(@l()))

  coord: @reactive 'coord', -> @model.get('coord')
  za:    @reactive 'za',    -> @model.get('za')
  l:     @reactive 'l',     -> @model.get('l')
  t:     @reactive 't',     -> @model.get('t')
  alpha: @reactive 'alpha', -> @model.get('alpha') * Math.PI/180
  z0:    @reactive 'z0',    -> @model.get('z0')

  z0element: @reactive 'z0element', ->
    if @coord() is 'eigen'
      @za() + @l() * Math.sin(@alpha()) / 2
    else
      @z0()

  Iy:    @reactive 'Iy',    ->
    @t() * @s(1) * Math.pow(@za(), 2) + @t() * @za() * Math.pow(@s(1), 2) * Math.sin(@alpha()) + @t() * Math.pow(@s(1), 3) / 3 * Math.pow(Math.sin(@alpha()), 2)
  IntSz: @reactive 'IntSz', ->
    @t() * ((@za() - @z0element()) * Math.pow(@s(1), 2)/2 + Math.sin(@alpha()) * Math.pow(@s(1), 3)/6)

  s:    @reactive 's',    (x) -> Math.abs(@l()) * x
  Sz_x: @reactive 'Sz_x', (x) -> @za() + Math.sin(@alpha()) * @l() * x
  Sz_y: @reactive 'Sz_y', (x) ->
    @t() * ((@za() - @z0element()) * @s(x) + Math.sin(@alpha()) * Math.pow(@s(x), 2)/2) / 100
  Sz: @memoize 'Sz', ->
    minY = null
    maxY = null
    points = []
    updateMinMax = (y) ->
    pushPoint = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    for i in [0..@accuracy]
      _x = i/@accuracy
      x = @Sz_y(_x)
      y = @Sz_x(_x)
      pushPoint(x, y)
    pushPoint(0, @Sz_x(1))

    {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  Ss_x: @reactive 'Ss_x', (x) -> @s(x) * Math.cos(@alpha()) - @Sz_y(x) * Math.sin(@alpha())
  Ss_y: @reactive 'Ss_y', (x) -> @s(x) * Math.sin(@alpha()) + @Sz_y(x) * Math.cos(@alpha()) + @za()
  Ss: @memoize 'Ss', ->
    minY = null
    maxY = null
    points = []
    updateMinMax = (y) ->
    pushPoint = (x, y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
      points.push(x, y)

    for i in [0..@accuracy]
      _x = i/@accuracy
      x = @Ss_x(_x)
      y = @Ss_y(_x)
      pushPoint(x, y)

    x1 = @l() * Math.cos(@alpha())
    y1 = @l() * Math.sin(@alpha()) + @za()
    pushPoint(x1, y1)

    {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  neutralAxis: @memoize 'neutralAxis', ->
    minY = null
    maxY = null
    points = []
    updateMinMax = (y) ->
    points = [
      - 2*@yRange()
      @z0element()
      2*@yRange()
      @z0element()
    ]
    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  # Geometry
  basicAy: @reactive 'basicAy', -> 0
  basicAz: @reactive 'basicAz', -> -@t()/2
  basicBy: @reactive 'basicBy', -> @l()
  basicBz: @reactive 'basicBz', -> -@t()/2
  basicCy: @reactive 'basicCy', -> @l()
  basicCz: @reactive 'basicCz', -> @t()/2
  basicDy: @reactive 'basicDy', -> 0
  basicDz: @reactive 'basicDz', -> @t()/2

  Ay: @reactive 'Ay', -> @basicAy() * Math.cos(@alpha()) - @basicAz() * Math.sin(@alpha())
  Az: @reactive 'Az', -> @basicAy() * Math.sin(@alpha()) + @basicAz() * Math.cos(@alpha()) + @za()
  By: @reactive 'By', -> @basicBy() * Math.cos(@alpha()) - @basicBz() * Math.sin(@alpha())
  Bz: @reactive 'Bz', -> @basicBy() * Math.sin(@alpha()) + @basicBz() * Math.cos(@alpha()) + @za()
  Cy: @reactive 'Cy', -> @basicCy() * Math.cos(@alpha()) - @basicCz() * Math.sin(@alpha())
  Cz: @reactive 'Cz', -> @basicCy() * Math.sin(@alpha()) + @basicCz() * Math.cos(@alpha()) + @za()
  Dy: @reactive 'Dy', -> @basicDy() * Math.cos(@alpha()) - @basicDz() * Math.sin(@alpha())
  Dz: @reactive 'Dz', -> @basicDy() * Math.sin(@alpha()) + @basicDz() * Math.cos(@alpha()) + @za()

  profile: @memoize 'profile', ->
    minY = null
    maxY = null
    points = []
    updateMinMax = (y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
    pushPoints = (args...) ->
      for i in [0..args.length-2] by 2
        points.push(args[i], args[i+1])
        updateMinMax(args[i+1])
    pushPoints(@Ay(), @Az(), @By(), @Bz(), @Cy(), @Cz(), @Dy(), @Dz(), @Ay(), @Az())
    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }
