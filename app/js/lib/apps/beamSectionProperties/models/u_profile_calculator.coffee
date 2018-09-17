ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.UProfileCalculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  profileWidth:       @reactive 'profileWidth',       -> @model.get('profileWidth')
  relFlangeThickness: @reactive 'relFlangeThickness', -> @model.get('relFlangeThickness')
  relWebThickness:    @reactive 'relWebThickness',    -> @model.get('relWebThickness')
  relLipThickness:    @reactive 'relLipThickness',    -> @model.get('relLipThickness')
  relWebHeight:       @reactive 'relWebHeight',       -> @model.get('relWebHeight')
  relLipHeight:       @reactive 'relLipHeight',       -> @model.get('relLipHeight')

  yRange: -> @webHeight()
  xRange: -> @webHeight()

  flangeThickness: @memoize 'flangeThickness', -> @relFlangeThickness() * @profileWidth()
  webThickness:    @memoize 'webThickness',    -> @relWebThickness()    * @profileWidth()
  lipThickness:    @memoize 'lipThickness',    -> @relLipThickness()    * @profileWidth()
  webHeight:       @memoize 'webHeight',       -> @relWebHeight()       * @profileWidth()
  lipHeight:       @memoize 'lipHeight',       ->
    if @relLipThickness() > 0 then @webHeight() * @relLipHeight() else 0

  Ax: @reactive 'Ax', -> - @webThickness() / 2
  Ay: @reactive 'Ay', -> 0

  Bx: @reactive 'Bx', -> @Ax()
  By: @reactive 'By', -> @webHeight() / 2

  Cx: @reactive 'Cx', -> @Ax() + @profileWidth() - @lipThickness()
  Cy: @reactive 'Cy', -> @By()

  Dx: @reactive 'Dx', -> @Cx()
  Dy: @reactive 'Dy', -> @By() - if @lipHeight() < 0 then @lipHeight() else 0

  Ex: @reactive 'Ex', -> @Ax() + @profileWidth()
  Ey: @reactive 'Ey', -> @Dy()

  Fx: @reactive 'Fx', -> @Ex()
  Fy: @reactive 'Fy', -> @By() - @flangeThickness() - if @lipHeight() > 0 then @lipHeight() else 0

  Gx: @reactive 'Gx', -> @Cx()
  Gy: @reactive 'Gy', -> @Fy()

  Hx: @reactive 'Hx', -> @Cx()
  Hy: @reactive 'Hy', -> @By() - @flangeThickness()

  Ix: @reactive 'Ix', -> @webThickness() / 2
  Iy: @reactive 'Iy', -> @Hy()

  Jx: @reactive 'Jx', -> @Ix()
  Jy: @reactive 'Jy', -> -@Iy()

  Kx: @reactive 'Kx', -> @Hx()
  Ky: @reactive 'Ky', -> -@Hy()

  Lx: @reactive 'Lx', -> @Gx()
  Ly: @reactive 'Ly', -> -@Gy()

  Mx: @reactive 'Mx', -> @Fx()
  My: @reactive 'My', -> -@Fy()

  Nx: @reactive 'Nx', -> @Ex()
  Ny: @reactive 'Ny', -> -@Ey()

  Ox: @reactive 'Ox', -> @Dx()
  Oy: @reactive 'Oy', -> -@Dy()

  Px: @reactive 'Px', -> @Cx()
  Py: @reactive 'Py', -> -@Cy()

  Qx: @reactive 'Qx', -> @Bx()
  Qy: @reactive 'Qy', -> -@By()

  Rx: @reactive 'Rx', -> @Ax()
  Ry: @reactive 'Ry', -> @Ay()

  thrustCenterX: @reactive 'thrustCenterX', -> - @staticMomentSy() / @inertiaIy()
  thrustCenterY: @reactive 'thrustCenterY', -> 0

  inertiaBase: @reactive 'inertiaBase', -> Math.pow(@webHeight(), 3) * @webThickness() / 12
  inertiaFlange: @reactive 'inertiaFlange', ->
    2*(Math.pow(@flangeThickness(), 3) * (@profileWidth() - @webThickness()) / 12 + Math.pow(@webHeight() - @flangeThickness(), 2)/4 * (@profileWidth() - @webThickness()) * @flangeThickness())
  inertiaEdge: @reactive 'inertiaEdge', ->
    base = if @relLipHeight() > 0 then 2 * @flangeThickness() else 0
    2*(@lipThickness() * Math.pow(Math.abs(@lipHeight()), 3) / 12 + @lipThickness() * Math.abs(@lipHeight()) * (Math.pow(@webHeight() - base - @lipHeight(), 2))/4)
  inertiaIy: @reactive 'inertiaIy', ->
    @inertiaBase() + @inertiaFlange() + @inertiaEdge()

  staticMomentLip: @reactive 'staticMomentLip', ->
    factor1 = @webHeight()/2 - @lipHeight() - if @relLipHeight() > 0 then 2 * @flangeThickness() else 0
    factor2 = if @relLipHeight() > 0 then 1 else -1
    @lipThickness() * (@profileWidth() - @webThickness() / 2 - @lipThickness()/2) * (Math.pow(Math.abs(@lipHeight()) + @flangeThickness()/2, 2)/2 * factor1 + factor2 * Math.pow(Math.abs(@lipHeight()) + @flangeThickness()/2, 3)/6)
  staticMomentSy0: @reactive 'staticMomentSy0', ->
    factor2 = if @relLipHeight() > 0 then 1 else -1
    @lipThickness() * (Math.abs(@lipHeight()) + @flangeThickness()/2) * ((@webHeight()/2 - (if @relLipHeight() > 0 then @flangeThickness() else 0) - @lipHeight()) + factor2 * (Math.abs(@lipHeight()) + @flangeThickness()/2)/2)
  staticMomentFlange: @reactive 'staticMomentFlange', ->
    (@webHeight() - @flangeThickness()) / 2 * (@staticMomentSy0() * (@profileWidth() - @webThickness() / 2 - @lipThickness()/2) + @flangeThickness() * (@webHeight() - @flangeThickness())/4 * Math.pow(@profileWidth() - @webThickness()/2 - @lipThickness() / 2, 2))
  staticMomentSy: @reactive 'staticMomentSy', ->
    factor1 = if @relLipHeight() > 0 then 1 else -1
    (@staticMomentFlange() + factor1 * @staticMomentLip()) * 2

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
    pushPoints(@Ax(), @Ay(), @Bx(), @By(), @Cx(), @Cy(), @Dx(), @Dy(), @Ex(), @Ey(), @Fx(), @Fy(), @Gx(), @Gy(), @Hx(), @Hy(), @Ix(), @Iy(), @Jx(), @Jy(), @Kx(), @Ky(), @Lx(), @Ly(), @Mx(), @My(), @Nx(), @Ny(), @Ox(), @Oy(), @Px(), @Py(), @Qx(), @Qy(), @Rx(), @Ry())
    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }
