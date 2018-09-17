ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.HalfCircleCalculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  yRange: => @outerYy() - @outerZy()
  xRange: => - @outerMz() * 2

  baseThickness:    @reactive 'baseThickness',    -> @model.get('baseThickness')
  relBaseThickness: @reactive 'relBaseThickness', -> @model.get('relBaseThickness')
  averageRadius:    @reactive 'averageRadius',    -> @model.get('averageRadius')

  relEdgeThickness: @reactive 'relEdgeThickness', -> 1 / @relBaseThickness()
  tCircle:          @reactive 'tCircle',          -> @baseThickness() / @relEdgeThickness()
  h:                @reactive 'h',                -> 2 * @averageRadius()

  openShearCenterX:   @reactive 'ysmo', ->
    -12 * @averageRadius() / (4 * @relEdgeThickness() + 3* Math.PI)

  closedShearCenterX: @reactive 'ysm', ->
    @openShearCenterX() + 8*Math.PI * @averageRadius() / (4*@relEdgeThickness() + 3 * Math.PI)/(1/@relEdgeThickness() + Math.PI/2)

  outerAy: @reactive 'outerAy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerAz(), 2))
  outerAz: @reactive 'outerAz', -> @baseThickness() / 2
  outerBy: @reactive 'outerBy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerBz(), 2))
  outerBz: @reactive 'outerBz', -> @outerAz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerCy: @reactive 'outerCy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerCz(), 2))
  outerCz: @reactive 'outerCz', -> @outerBz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerDy: @reactive 'outerDy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerDz(), 2))
  outerDz: @reactive 'outerDz', -> @outerCz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerEy: @reactive 'outerEy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerEz(), 2))
  outerEz: @reactive 'outerEz', -> @outerDz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerFy: @reactive 'outerFy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerFz(), 2))
  outerFz: @reactive 'outerFz', -> @outerEz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerGy: @reactive 'outerGy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerGz(), 2))
  outerGz: @reactive 'outerGz', -> @outerFz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerHy: @reactive 'outerHy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerHz(), 2))
  outerHz: @reactive 'outerHz', -> @outerGz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerIy: @reactive 'outerIy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerIz(), 2))
  outerIz: @reactive 'outerIz', -> @outerHz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerJy: @reactive 'outerJy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerJz(), 2))
  outerJz: @reactive 'outerJz', -> @outerIz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerKy: @reactive 'outerKy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerKz(), 2))
  outerKz: @reactive 'outerKz', -> @outerJz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/50
  outerLy: @reactive 'outerLy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerLz(), 2))
  outerLz: @reactive 'outerLz', -> @outerKz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/20
  outerMy: @reactive 'outerMy', -> 0
  outerMz: @reactive 'outerMz', -> @outerJz() - ((@baseThickness() + @tCircle())/2 + @averageRadius())/10
  outerNy: @reactive 'outerNy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerNz(), 2))
  outerNz: @reactive 'outerNz', -> @outerLz()
  outerOy: @reactive 'outerOy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerOz(), 2))
  outerOz: @reactive 'outerOz', -> @outerKz()
  outerPy: @reactive 'outerPy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerPz(), 2))
  outerPz: @reactive 'outerPz', -> @outerMz() + (@baseThickness() + @averageRadius()) / 10
  outerQy: @reactive 'outerQy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerQz(), 2))
  outerQz: @reactive 'outerQz', -> @outerPz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerRy: @reactive 'outerRy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerRz(), 2))
  outerRz: @reactive 'outerRz', -> @outerQz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerSy: @reactive 'outerSy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerSz(), 2))
  outerSz: @reactive 'outerSz', -> @outerRz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerTy: @reactive 'outerTy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerTz(), 2))
  outerTz: @reactive 'outerTz', -> @outerSz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerUy: @reactive 'outerUy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerUz(), 2))
  outerUz: @reactive 'outerUz', -> @outerTz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerVy: @reactive 'outerVy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerVz(), 2))
  outerVz: @reactive 'outerVz', -> @outerUz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerWy: @reactive 'outerWy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerWz(), 2))
  outerWz: @reactive 'outerWz', -> @outerVz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerXy: @reactive 'outerXy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerXz(), 2))
  outerXz: @reactive 'outerXz', -> @outerWz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerYy: @reactive 'outerYy', -> Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerYz(), 2))
  outerYz: @reactive 'outerYz', -> @outerXz() + ((@baseThickness() + @tCircle()) / 2 + @averageRadius()) / 10
  outerZy: @reactive 'outerZy', -> - Math.sqrt(Math.pow(@averageRadius() + @tCircle()/2, 2) - Math.pow(@outerZz(), 2))
  outerZz: @reactive 'outerZz', -> @outerYz()
  innerAy: @reactive 'innerAy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerAz(), 2))
  innerAz: @reactive 'innerAz', -> - @outerAz()
  innerBy: @reactive 'innerBy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerBz(), 2))
  innerBz: @reactive 'innerBz', -> @innerAz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerCy: @reactive 'innerCy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerCz(), 2))
  innerCz: @reactive 'innerCz', -> @innerBz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerDy: @reactive 'innerDy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerDz(), 2))
  innerDz: @reactive 'innerDz', -> @innerCz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerEy: @reactive 'innerEy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerEz(), 2))
  innerEz: @reactive 'innerEz', -> @innerDz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerFy: @reactive 'innerFy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerFz(), 2))
  innerFz: @reactive 'innerFz', -> @innerEz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerGy: @reactive 'innerGy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerGz(), 2))
  innerGz: @reactive 'innerGz', -> @innerFz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerHy: @reactive 'innerHy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerHz(), 2))
  innerHz: @reactive 'innerHz', -> @innerGz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerIy: @reactive 'innerIy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerIz(), 2))
  innerIz: @reactive 'innerIz', -> @innerHz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerJy: @reactive 'innerJy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerJz(), 2))
  innerJz: @reactive 'innerJz', -> @innerIz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerKy: @reactive 'innerKy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerKz(), 2))
  innerKz: @reactive 'innerKz', -> @innerJz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/20
  innerLy: @reactive 'innerLy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerLz(), 2))
  innerLz: @reactive 'innerLz', -> @innerKz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/50
  innerMy: @reactive 'innerMy', -> 0
  innerMz: @reactive 'innerMz', -> @innerJz() - (@averageRadius() - (@baseThickness() + @tCircle())/2)/10
  innerNy: @reactive 'innerNy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerNz(), 2))
  innerNz: @reactive 'innerNz', -> @innerLz()
  innerOy: @reactive 'innerOy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerOz(), 2))
  innerOz: @reactive 'innerOz', -> @innerKz()
  innerPy: @reactive 'innerPy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerPz(), 2))
  innerPz: @reactive 'innerPz', -> @innerMz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerQy: @reactive 'innerQy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerQz(), 2))
  innerQz: @reactive 'innerQz', -> @innerPz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerRy: @reactive 'innerRy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerRz(), 2))
  innerRz: @reactive 'innerRz', -> @innerQz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerSy: @reactive 'innerSy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerSz(), 2))
  innerSz: @reactive 'innerSz', -> @innerRz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerTy: @reactive 'innerTy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerTz(), 2))
  innerTz: @reactive 'innerTz', -> @innerSz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerUy: @reactive 'innerUy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerUz(), 2))
  innerUz: @reactive 'innerUz', -> @innerTz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerVy: @reactive 'innerVy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerVz(), 2))
  innerVz: @reactive 'innerVz', -> @innerUz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerWy: @reactive 'innerWy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerWz(), 2))
  innerWz: @reactive 'innerWz', -> @innerVz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerXy: @reactive 'innerXy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerXz(), 2))
  innerXz: @reactive 'innerXz', -> @innerWz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerYy: @reactive 'innerYy', -> Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerYz(), 2))
  innerYz: @reactive 'innerYz', -> @innerXz() + (@averageRadius() - (@baseThickness() + @tCircle()) / 2) / 10
  innerZy: @reactive 'innerZy', -> - Math.sqrt(Math.pow(@averageRadius() - @tCircle()/2, 2) - Math.pow(@innerZz(), 2))
  innerZz: @reactive 'innerZz', -> @innerYz()

  profile: @memoize 'profile', ->
    minY = null
    maxY = null
    points = [[],[],[],[]]
    updateMinMax = (y) ->
      minY = y if not minY? or y < minY
      maxY = y if not maxY? or y > maxY
    pushPoints = (num, args...) ->
      for i in [0..args.length-2] by 2
        points[num].push(args[i+1], args[i])
        updateMinMax(args[i])
    pushPoints(0, @innerAy(), @innerAz(), @innerBy(), @innerBz(), @innerCy(), @innerCz(), @innerDy(), @innerDz(), @innerEy(), @innerEz(), @innerFy(), @innerFz(), @innerGy(), @innerGz(), @innerHy(), @innerHz(), @innerIy(), @innerIz(), @innerJy(), @innerJz(), @innerKy(), @innerKz(), @innerLy(), @innerLz(), @innerMy(), @innerMz(), @innerNy(), @innerNz(), @innerOy(), @innerOz(), @innerPy(), @innerPz(), @innerQy(), @innerQz(), @innerRy(), @innerRz(), @innerSy(), @innerSz(), @innerTy(), @innerTz(), @innerUy(), @innerUz(), @innerVy(), @innerVz(), @innerWy(), @innerWz(), @innerXy(), @innerXz(), @innerYy(), @innerYz())
    pushPoints(1, @outerZy(), @outerZz(), @outerBy(), @outerBz(), @outerCy(), @outerCz(), @outerDy(), @outerDz(), @outerEy(), @outerEz(), @outerFy(), @outerFz(), @outerGy(), @outerGz(), @outerHy(), @outerHz(), @outerIy(), @outerIz(), @outerJy(), @outerJz(), @outerKy(), @outerKz(), @outerLy(), @outerLz(), @outerMy(), @outerMz(), @outerNy(), @outerNz(), @outerOy(), @outerOz(), @outerPy(), @outerPz(), @outerQy(), @outerQz(), @outerRy(), @outerRz(), @outerSy(), @outerSz(), @outerTy(), @outerTz(), @outerUy(), @outerUz(), @outerVy(), @outerVz(), @outerWy(), @outerWz(), @outerXy(), @outerXz(), @outerYy(), @outerYz())
    pushPoints(2, @innerYy(), @innerYz(), @innerZy(), @innerZz())
    pushPoints(3, @outerYy(), @outerYz(), @outerZy(), @outerZz())
    return {
      points: points
      minY: minY
      maxY: maxY
      tension: 0.25
      multiplePaths: true
    }
