ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Views ?= {}
class ILR.BeamSectionProperties.Views.UProfileGraph extends ILR.Views.InterpolatedGraph
  initialize: ->
    super

  bindCalculatorEvents: ->
    super
    for calc in @model.get('calculators')
      for curve in @model.curves.history
        @listenTo calc, 'change:thrustCenterX', @requestRepaint

  render: ->
    super
    @context.beginPath()
    xPos = 20
    yPos =  -20 + @height
    @context.arc(xPos, yPos, 5, 0, 2 * Math.PI, false)
    @context.fillStyle = 'red'
    @context.fill()
    @context.textBaseline = 'middle'
    @context.fillStyle = 'black'
    @context.fillText(t('beamSectionProperties.uProfile.graph.shearCenter.label'), xPos + 20, yPos)
    @context.closePath()

    @context.beginPath()
    calc = @model.get('calculators')[0]
    x = calc.thrustCenterX()
    y = 0
    xPos = @xOrigin + x * @width / @xRange
    yRange = @maxRangeY()
    yPos = @yOrigin - y * @height / yRange
    @context.arc(xPos, yPos, 20, 0, 2 * Math.PI, false)
    @context.fillStyle = 'red'
    @context.fill()
    @context.closePath()
    this
