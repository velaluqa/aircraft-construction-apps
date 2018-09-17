ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Views ?= {}
class ILR.BeamSectionProperties.Views.HalfCircleGraph extends ILR.Views.InterpolatedGraph
  initialize: ->
    super

  bindCalculatorEvents: ->
    super
    for calc in @model.get('calculators')
      for curve in @model.curves.history
        @listenTo calc, "change:closedShearCenterX", @requestRepaint
        @listenTo calc, "change:openShearCenterX", @requestRepaint

  render: ->
    super
    @context.beginPath()
    xPos = 20
    yPos =  -20 + @height
    @context.arc(xPos, yPos, 5, 0, 2 * Math.PI, false)
    @context.fillStyle = 'blue'
    @context.fill()
    @context.textBaseline = 'middle'
    @context.fillStyle = 'black'
    @context.fillText(@loadLocale('graph.closedShearCenter.label'), xPos+20, yPos)
    @context.closePath()

    @context.beginPath()
    xPos = 20
    yPos =  -40 + @height
    @context.arc(xPos, yPos, 5, 0, 2 * Math.PI, false)
    @context.fillStyle = 'red'
    @context.fill()
    @context.textBaseline = 'middle'
    @context.fillStyle = 'black'
    @context.fillText(@loadLocale('graph.openShearCenter.label'), xPos+20, yPos)
    @context.closePath()

    @context.beginPath()
    calc = @model.get('calculators')[0]
    x = calc.openShearCenterX()
    y = 0
    xPos = @xOrigin + x * @width / @xRange
    yRange = @maxRangeY()
    yPos = @yOrigin - y * @height / yRange
    @context.arc(xPos, yPos, 10, 0, 2 * Math.PI, false)
    @context.fillStyle = 'red'
    @context.fill()
    @context.closePath()

    @context.beginPath()
    calc = @model.get('calculators')[0]
    x = calc.closedShearCenterX()
    y = 0
    xPos = @xOrigin + x * @width / @xRange
    yRange = @maxRangeY()
    yPos = @yOrigin - y * @height / yRange
    @context.arc(xPos, yPos, 10, 0, 2 * Math.PI, false)
    @context.fillStyle = 'blue'
    @context.fill()
    @context.closePath()

    this
