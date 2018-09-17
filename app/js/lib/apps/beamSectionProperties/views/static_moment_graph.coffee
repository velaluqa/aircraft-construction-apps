ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Views ?= {}
class ILR.BeamSectionProperties.Views.StaticMomentGraph extends ILR.Views.InterpolatedGraph
  initialize: ->
    super

  bindCalculatorEvents: ->
    super
    for calc in @model.get('calculators')
      for curve in @model.curves.history
        @listenTo calc, "change:thrustCenterX", @requestRepaint

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
      @context.fillText(@Present(curve).label(), xPos+25, yPos)
      @context.closePath()
      i += 1

    this
