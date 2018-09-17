ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Views ?= {}
class ILR.BeamSectionProperties.Views.ZProfileGraph extends ILR.Views.InterpolatedGraph
  initialize: ->
    super

  bindCalculatorEvents: ->
    super
    for calc in @model.get('calculators')
      for curve in @model.curves.history
        @listenTo calc, "change:IyRadius", @requestRepaint
        @listenTo calc, "change:IzRadius", @requestRepaint
        @listenTo calc, "change:IyzRadius", @requestRepaint

  render: ->
    super

    @context.textBaseline = 'middle'
    i = 1
    for curve in @model.curves.history when curve.get('function') isnt 'profile'
      @context.beginPath()
      xPos = 15
      yPos = (-20*i) + @height
      @context.moveTo(xPos, yPos)
      @context.lineTo(xPos+15, yPos)
      @context.strokeStyle = curve.strokeStyle()
      @context.stroke()
      @context.fillStyle = 'black'
      label = @loadLocale("curves.#{curve.get('function')}.label", alfa: @model.get('alfa'))
      @context.fillText(label, xPos+25, yPos)
      @context.closePath()
      i += 1

    @context.beginPath()
    xPos = 22
    yPos = (-20*i) + @height
    @context.arc(xPos, yPos, 5, 0, 2 * Math.PI, false)
    @context.fillStyle = 'red'
    @context.fill()
    @context.fillStyle = 'black'
    func = curve.get('function')
    label = @loadLocale('curves.Iz.label', alfa: @model.get('alfa'))
    @context.fillText(label, xPos+18, yPos)
    @context.closePath()
    i += 1

    @context.beginPath()
    xPos = 22
    yPos = (-20*i) + @height
    @context.arc(xPos, yPos, 5, 0, 2 * Math.PI, false)
    @context.fillStyle = 'blue'
    @context.fill()
    @context.fillStyle = 'black'
    func = curve.get('function')
    label = @loadLocale('curves.Iy.label', alfa: @model.get('alfa'))
    @context.fillText(label, xPos+18, yPos)
    @context.closePath()
    i += 1

    @context.beginPath()
    calc = @model.get('calculators')[0]
    x = calc.Iz_h()
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
    x = 0
    y = calc.Iy_h()
    xPos = @xOrigin + x * @width / @xRange
    yRange = @maxRangeY()
    yPos = @yOrigin - y * @height / yRange
    @context.arc(xPos, yPos, 10, 0, 2 * Math.PI, false)
    @context.fillStyle = 'blue'
    @context.fill()
    @context.closePath()


    this
