ILR.ThinWalledCantilever ?= {}
ILR.ThinWalledCantilever.Models ?= {}
class ILR.ThinWalledCantilever.Models.Calculator extends ILR.Models.BaseCalculator
  accuracy_x: null
  accuracy_y: null
  interpolationTension: 0
  z_segments: 4 # Amount of horizontal segments, amount should be a divisor of accuracy
  x_segments: 4 # Amount of vertical segments, amount should be a divisor of accuracy

  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  yRange: (func) -> 1 # axis is linked
  xRange: (func) -> @model.defaults().length * 1.1

  load:       @reactive 'load',       -> @model.get('load')
  length:     @reactive 'length',     -> @model.get('length')
  height:     @reactive 'height',     -> @model.get('height')
  thickness:  @reactive 'thickness',  -> @model.get('thickness')
  E:          @reactive 'E',          -> @model.get('E') * 1000
  nue:        @reactive 'nue',        -> @model.get('nue')
  continuous: @reactive 'continuous', -> @model.get('continuous') is 'yes'

  I: @reactive 'I', ->
    @thickness() * Math.pow(@height(), 3) / 12

  G: @reactive 'G', ->
    0.5 * @E() / ( 1 + @nue() )

  _accuracy_x: @reactive '_accuracy_x', ->
    v = Math.max(@accuracy_x or 0.04 * @length(), 10)
    # round up to next number divisible by x_segments
    @x_segments * Math.ceil( v / @x_segments )

  _accuracy_y: @reactive '_accuracy_y', ->
    v = @accuracy_y or 0.08 * @height()
    # round up to next number divisible by z_segments
    @z_segments * Math.ceil( v / @z_segments )

  pei: @memoize 'pei', ->
    @load() / @E() / @I()

  pgi: @memoize 'pgi', ->
    @load() / @G() / @I()

  w: @reactive 'w', (x) ->
    sq_x = x * x
    -@pei() * ( 0.5 * @length() * sq_x - sq_x * x / 6 )

  w_ded: @reactive 'w_ded', (x) ->
    -@pei() * ( @length() * x - 0.5 * x * x)

  orthogonal_point_left: @reactive 'orthogonal_point_left', (ded, dis, x0, y0) ->
    if ded is 0
      x = x0
      y = y0 + dis
    else
      sq_ded = ded * ded
      x = ( x0*sq_ded + x0 + dis * Math.sqrt( sq_ded * sq_ded + sq_ded ) ) / (sq_ded + 1)
      y = - x / ded + y0 + x0 / ded
    [x, y]

  beam: @memoize 'beam', ->
    h_outline = { points: [[], []], multiplePaths: true, tension: 0.5 }
    v_outline = { points: [[], []], multiplePaths: true, tension: 0 }
    h_grid = { points: [], multiplePaths: true, tension: 0 }
    v_grid = { points: [], multiplePaths: true, tension: 0 }

    accuracy_x = @_accuracy_x()

    for i in [2..@z_segments]
      h_grid.points.push([])

    for i in [0..accuracy_x]
      bending = []
      x = i / accuracy_x * @length()
      y = @w(x)

      for z_offset in [0..@z_segments]
        z = (z_offset / @z_segments - 0.5) * @height()
        [xn, yn] = @orthogonal_point_left(@w_ded(x), z, x, y)
        if z_offset is 0
          h_outline.points[0].push(xn, yn)
        else if z_offset is @z_segments
          h_outline.points[1].push(xn, yn)
        else
          h_grid.points[z_offset-1].push(xn, yn)

    # Add vertical curves
    v_outline.points[0].push(h_outline.points[0][0], h_outline.points[0][1])
    v_outline.points[0].push(h_outline.points[1][0], h_outline.points[1][1])
    v_outline.points[1].push(h_outline.points[0][2*accuracy_x], h_outline.points[0][2*accuracy_x+1])
    v_outline.points[1].push(h_outline.points[1][2*accuracy_x], h_outline.points[1][2*accuracy_x+1])
    for x in [0..accuracy_x] by accuracy_x / @x_segments
      unless x is 0 or x is accuracy_x
        v_curve = []
        v_curve.push(h_outline.points[0][2*x], h_outline.points[0][2*x+1])
        v_curve.push(h_outline.points[1][2*x], h_outline.points[1][2*x+1])
        v_grid.points.push(v_curve)

    return {
      h_outline: h_outline
      v_outline: v_outline
      h_grid: h_grid
      v_grid: v_grid
    }

  c1: @memoize 'c1', (z, sq_height) ->
    ret = 0
    if @continuous()
      ret += @nue() * @pei() * 0.5 * z
    ret - 0.125 * @pgi() * sq_height

  c1_dist: @memoize 'c1_dist', ->
    sq_height = @height() * @height()
    z1 = @height() / 2
    z0 = -z1
    if @continuous()
      c1_z0 = @c1(z0, sq_height)
      c1_z1 = @c1(z1, sq_height)
      return {
        points: [z0, c1_z0, z1, c1_z1]
      }
    else
      c1 = @c1(z0, sq_height)
      return {
        points: [z0, c1, z1, c1]
      }

  d1: @memoize 'd1', (z, tr_z, sq_height) ->
    if @continuous()
      - @load() / 6 / @I() * ( 1 / @G() - @nue() / @E()) * tr_z - @c1(z, sq_height) * z
    else
      0

  d1_dist: @memoize 'd1_dist', ->
    height = @height()
    sq_height = height * height
    if @continuous()
      points = []
      accuracy_y = @_accuracy_y()
      for iz in [0..accuracy_y]
        z = (iz / accuracy_y - 0.5) * height
        d1 =  @d1(z, z * z * z, sq_height)
        points.push(z, d1)
      return { points: points, tension: 0.5 }
    else
      z1 = height / 2
      z0 = -z1
      return {
        points: [z0, 0, z1, 0]
      }

  d2: @memoize 'd2', (sq_z) ->
    if @continuous()
      @nue() * @pei() * @length() * 0.5 * sq_z
    else
      0

  d2_dist: @memoize 'd2_dist', ->
    height = @height()
    if @continuous()
      points = []
      accuracy_y = @_accuracy_y()
      for iz in [0..accuracy_y]
        z = (iz / accuracy_y - 0.5) * height
        d2 = @d2(z * z)
        points.push(z, d2)
      return { points: points, tension: 0.5 }
    else
      z1 = height / 2
      z0 = -z1
      return {
        points: [z0, 0, z1, 0]
      }

  w_slice: @reactive 'w_slice', (x0, z) ->
    sq_x0 = x0 * x0
    sq_z = z * z
    tr_z = sq_z * z
    sq_height = @height() * @height()
    x = x0 + @pei() * (@length()*x0 - 0.5 * sq_x0) * z + @load() / 6 / @I() * (1/@G() - @nue() / @E()) * tr_z + @c1(z, sq_height) * z + @d1(z, tr_z, sq_height)
    y = z - @pei() * (0.5*@length()*sq_x0 - sq_x0 * x0 / 6) - @nue() * @pei() * (@length() - x0) * 0.5 * sq_z
    if @continuous()
      y += - @c1(z, sq_height) * x0 - 0.125 * @pgi() * sq_height * x0 + @d2(sq_z)
    { x: x, y: y }

  slice: @memoize 'slice', ->
    h_outline = { points: [[], []], multiplePaths: true, tension: 0.5 }
    v_outline = { points: [[], []], multiplePaths: true, tension: 0.5 }
    h_grid = { points: [], multiplePaths: true, tension: 0.5 }
    v_grid = { points: [], multiplePaths: true, tension: 0.5 }

    accuracy_x = @_accuracy_x()
    accuracy_y = @_accuracy_y()

    for ix in [0..accuracy_x]
      x0 = ix / accuracy_x * @length()
      for iz in [0..accuracy_y]
        z = (iz / accuracy_y - 0.5) * @height()

        res = null

        if iz is 0
          res ||= @w_slice(x0, z)
          h_outline.points[0].push(res.x, res.y)
        else if iz is accuracy_y
          res ||= @w_slice(x0, z)
          h_outline.points[1].push(res.x, res.y)
        else if (z_idx = iz * @z_segments / accuracy_y) is Math.floor(z_idx)
          res ||= @w_slice(x0, z)
          h_grid.points[z_idx-1] = [] if ix is 0
          h_grid.points[z_idx-1].push(res.x, res.y)

        if ix is 0
          res ||= @w_slice(x0, z)
          v_outline.points[0].push(res.x, res.y)
        else if ix is accuracy_x
          res ||= @w_slice(x0, z)
          v_outline.points[1].push(res.x, res.y)
        else if (x_idx = ix * @x_segments / accuracy_x) is Math.floor(x_idx)
          res ||= @w_slice(x0, z)
          v_grid.points[x_idx-1] = [] if iz is 0
          v_grid.points[x_idx-1].push(res.x, res.y)

    return {
      h_outline: h_outline
      v_outline: v_outline
      h_grid: h_grid
      v_grid: v_grid
    }
