ILR.InternationalStandardAtmosphere ?= {}
ILR.InternationalStandardAtmosphere.Views ?= {}
class ILR.InternationalStandardAtmosphere.Views.Graph extends ILR.Views.InterpolatedGraph

  initialize: ->
    super
    @calc = @model.get('calculators')[0]
    @yRange = @calc.yRange()

  beforeRenderCurves: ->
    @renderAtmosphereSections()

  renderAtmosphereSections: ->
    @context.strokeStyle = '#999'
    @context.lineWidth = 2
    @context.setLineDash [2, 2]
    @context.textAlign = 'center'

    @context.beginPath()

    tropopauseVal = @calc.TROPOPAUSE
    tropopause = @yOrigin - tropopauseVal * @height / @yRange
    @context.moveTo(@xOrigin, tropopause)
    @context.lineTo(@width, tropopause)

    subStratopauseVal = @calc.SUB_STRATOPAUSE
    subStratopause = @yOrigin - subStratopauseVal * @height / @yRange
    @context.moveTo(@xOrigin, subStratopause)
    @context.lineTo(@width, subStratopause)

    midStratopauseVal = @calc.MID_STRATOPAUSE
    midStratopause = @yOrigin - midStratopauseVal * @height / @yRange
    @context.moveTo(@xOrigin, midStratopause)
    @context.lineTo(@width, midStratopause)

    @context.stroke()

    @context.fillText('Tropopause', Math.max(@xOrigin, @width / 2), tropopause + 6)

    xPos = @xOrigin + (@width - @xOrigin) / 4
    if xPos < 35
      xPos = @width / 2
    @context.fillText('Troposphere', Math.max(@xOrigin, xPos), (tropopause + @yOrigin) / 2)

    @context.fillText('Sub-Stratosphere', Math.max(@xOrigin, @width / 2), (tropopause + subStratopause) / 2)
    @context.fillText('Mid-Stratosphere', Math.max(@xOrigin, @width / 2), (midStratopause + subStratopause) / 2)

    @context.closePath()
