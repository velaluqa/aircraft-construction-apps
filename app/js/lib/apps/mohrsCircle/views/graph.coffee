ILR.MohrsCircle ?= {}
ILR.MohrsCircle.Views ?= {}
class ILR.MohrsCircle.Views.Graph extends ILR.Views.InterpolatedGraph
  initialize: ->
    super

  render: ->
    super

    @context.textBaseline = 'middle'
    i = 1
    for curve in @model.curves.history when curve.get('function') isnt 'circle'
      @context.beginPath()
      xPos = 15
      yPos = (-20*i) + @height
      @context.moveTo(xPos, yPos)
      @context.lineTo(xPos+15, yPos)
      @context.strokeStyle = curve.strokeStyle()
      @context.stroke()
      @context.fillStyle = 'black'
      func = curve.get('function')
      label = t("mohrsCircle.curves.#{func}.label", alfa: @model.get('alfa'))
      @context.fillText(label, xPos+25, yPos)
      @context.closePath()
      i += 1

    this
