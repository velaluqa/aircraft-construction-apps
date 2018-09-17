ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.ZProfileCalculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  yRange: -> @baseAy() * 2
  xRange: -> @baseAy() * 2

  h:    @reactive 'h',    -> @model.get('h')
  b:    @reactive 'b',    -> @model.get('b')
  tf:   @reactive 'tf',   -> @model.get('tf')
  ts:   @reactive 'ts',   -> @model.get('ts')
  alfa: @reactive 'alfa', -> @model.get('alfa') * Math.PI/180

  baseAx: @reactive 'baseAx', ->
    b = if @tf() > 0 then @b() else 0
    -(b + @ts() / 2)
  baseAy: @reactive 'baseAy', -> @h() / 2 + @tf()
  baseBx: @reactive 'baseBx', -> @baseAx()
  baseBy: @reactive 'baseBy', -> @h() / 2
  baseCx: @reactive 'baseCx', -> - @ts() / 2
  baseCy: @reactive 'baseCy', -> @baseBy()
  baseDx: @reactive 'baseDx', -> @baseCx()
  baseDy: @reactive 'baseDy', -> - @baseAy()
  baseEx: @reactive 'baseEx', -> - @baseAx()
  baseEy: @reactive 'baseEy', -> - @baseAy()
  baseFx: @reactive 'baseFx', -> - @baseBx()
  baseFy: @reactive 'baseFy', -> - @baseBy()
  baseGx: @reactive 'baseGx', -> - @baseCx()
  baseGy: @reactive 'baseGy', -> @baseFy()
  baseHx: @reactive 'baseHx', -> @baseGx()
  baseHy: @reactive 'baseHy', -> @baseAy()
  baseIx: @reactive 'baseIx', -> @baseAx()
  baseIy: @reactive 'baseIy', -> @baseAy()

  baseProfile: @memoize 'baseProfile', ->
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
    pushPoints(@baseAx(), @baseAy(), @baseBx(), @baseBy(), @baseCx(), @baseCy(), @baseDx(), @baseDy(), @baseEx(), @baseEy(), @baseFx(), @baseFy(), @baseGx(), @baseGy(), @baseHx(), @baseHy(), @baseIx(), @baseIy())
    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  x0: -> 0
  y0: -> 0

  rotAx: @reactive 'rotAx', ->   @baseAx() * Math.cos(@alfa()) + @baseAy() * Math.sin(@alfa())
  rotAy: @reactive 'rotAy', -> - @baseAx() * Math.sin(@alfa()) + @baseAy() * Math.cos(@alfa())
  rotBx: @reactive 'rotBx', ->   @baseBx() * Math.cos(@alfa()) + @baseBy() * Math.sin(@alfa())
  rotBy: @reactive 'rotBy', -> - @baseBx() * Math.sin(@alfa()) + @baseBy() * Math.cos(@alfa())
  rotCx: @reactive 'rotCx', ->   @baseCx() * Math.cos(@alfa()) + @baseCy() * Math.sin(@alfa())
  rotCy: @reactive 'rotCy', -> - @baseCx() * Math.sin(@alfa()) + @baseCy() * Math.cos(@alfa())
  rotDx: @reactive 'rotDx', ->   @baseDx() * Math.cos(@alfa()) + @baseDy() * Math.sin(@alfa())
  rotDy: @reactive 'rotDy', -> - @baseDx() * Math.sin(@alfa()) + @baseDy() * Math.cos(@alfa())
  rotEx: @reactive 'rotEx', ->   @baseEx() * Math.cos(@alfa()) + @baseEy() * Math.sin(@alfa())
  rotEy: @reactive 'rotEy', -> - @baseEx() * Math.sin(@alfa()) + @baseEy() * Math.cos(@alfa())
  rotFx: @reactive 'rotFx', ->   @baseFx() * Math.cos(@alfa()) + @baseFy() * Math.sin(@alfa())
  rotFy: @reactive 'rotFy', -> - @baseFx() * Math.sin(@alfa()) + @baseFy() * Math.cos(@alfa())
  rotGx: @reactive 'rotGx', ->   @baseGx() * Math.cos(@alfa()) + @baseGy() * Math.sin(@alfa())
  rotGy: @reactive 'rotGy', -> - @baseGx() * Math.sin(@alfa()) + @baseGy() * Math.cos(@alfa())
  rotHx: @reactive 'rotHx', ->   @baseHx() * Math.cos(@alfa()) + @baseHy() * Math.sin(@alfa())
  rotHy: @reactive 'rotHy', -> - @baseHx() * Math.sin(@alfa()) + @baseHy() * Math.cos(@alfa())
  rotIx: @reactive 'rotIx', ->   @baseIx() * Math.cos(@alfa()) + @baseIy() * Math.sin(@alfa())
  rotIy: @reactive 'rotIy', -> - @baseIx() * Math.sin(@alfa()) + @baseIy() * Math.cos(@alfa())

  rotProfile: @memoize 'rotProfile', ->
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
    pushPoints(@rotAx(), @rotAy(), @rotBx(), @rotBy(), @rotCx(), @rotCy(), @rotDx(), @rotDy(), @rotEx(), @rotEy(), @rotFx(), @rotFy(), @rotGx(), @rotGy(), @rotHx(), @rotHy(), @rotIx(), @rotIy())
    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0
    }

  IyAlpha0:  @reactive 'IyAlpha0',  -> Math.pow(@h(), 3) * @ts() / 12 + (Math.pow(@h(), 2) * @tf() / 2 + @h() * Math.pow(@tf(), 2) + 2 * Math.pow(@tf(), 3) / 3) * (@ts() + @b())
  IzAlpha0:  @reactive 'IzAlpha0',  -> @h() * Math.pow(@ts(), 3) / 12 + @tf() * Math.pow(@ts(), 3) / 6 + 2 * @tf() * Math.pow(@b(), 3) / 3 + @tf() * Math.pow(@ts(), 2) * @b() / 2 + @tf() * @ts() * Math.pow(@b(), 2)
  IyzAlpha0: @reactive 'IyzAlpha0', -> -(@b() + @ts()) * (@h() + @tf()) * @b() * @tf() / 2

  IyAlphaX:  @reactive 'IyAlphaX',  ->     @IyAlpha0()     * Math.pow(Math.cos(@alfa()), 2) + @IzAlpha0()     * Math.pow(Math.sin(@alfa()), 2)  - @IyzAlpha0() * Math.sin(2*@alfa())
  IzAlphaX:  @reactive 'IzAlphaX',  ->     @IyAlpha0()     * Math.pow(Math.sin(@alfa()), 2) + @IzAlpha0()     * Math.pow(Math.cos(@alfa()), 2)  + @IyzAlpha0() * Math.sin(2*@alfa())
  IyzAlphaX: @reactive 'IyzAlphaX', -> -(- @IyAlpha0() / 2 *          Math.sin(@alfa() * 2) + @IzAlpha0() / 2 *          Math.sin(@alfa() * 2)  - @IyzAlpha0() * Math.cos(2*@alfa()))

  IyRadius:  @reactive 'IyRadius',  -> @IyAlphaX() / @IyAlpha0()
  IzRadius:  @reactive 'IzRadius',  -> @IzAlphaX() / @IzAlpha0()
  IyzRadius: @reactive 'IyzRadius', -> @IyzAlphaX() / @IyzAlpha0()

  Iy: @memoize 'Iy', ->
    radius = Math.abs(@IyRadius())
    return {
      center: [0, 0]
      radius: radius
      minY: radius
      maxY: radius
    }
  Iz: @memoize 'Iz', ->
    radius = Math.abs(@IzRadius())
    return {
      center: [0, 0]
      radius: radius
      minY: radius
      maxY: radius
    }
  Iyz: @memoize 'Iyz', ->
    radius = Math.abs(@IyzRadius())
    return {
      center: [0, 0]
      radius: radius
      minY:   radius
      maxY:   radius
    }

  A:    @reactive 'A',    -> 2 * @b() * @tf() + @h() * @ts()
  Iy_h: @reactive 'Iy_h', -> Math.sqrt(@IyAlphaX() / @A())
  Iz_h: @reactive 'Iz_h', -> Math.sqrt(@IzAlphaX() / @A())
