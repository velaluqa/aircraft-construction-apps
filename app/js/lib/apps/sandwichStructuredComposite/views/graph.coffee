ILR.SandwichStructuredComposite ?= {}
ILR.SandwichStructuredComposite.Views ?= {}
class ILR.SandwichStructuredComposite.Views.Graph extends ILR.Views.InterpolatedGraph

  beforeRenderCurves: ->
    @renderTriangles()

  SIZE: 15
  renderTriangles: ->
    @context.strokeStyle = '#000'
    @context.lineWidth = 1
    @context.setLineDash []

    @context.beginPath()

    # left
    @context.moveTo(@xOrigin, @yOrigin)
    @context.lineTo(@xOrigin + @SIZE, @yOrigin + @SIZE)
    @context.lineTo(@xOrigin - @SIZE, @yOrigin + @SIZE)
    @context.lineTo(@xOrigin, @yOrigin)

    # right
    length = @xOrigin + @model.get('length') * @width / @xRange
    @context.moveTo(length, @yOrigin)
    @context.lineTo(length + @SIZE, @yOrigin + @SIZE)
    @context.lineTo(length - @SIZE, @yOrigin + @SIZE)
    @context.lineTo(length, @yOrigin)

    @context.stroke()
    @context.closePath()
