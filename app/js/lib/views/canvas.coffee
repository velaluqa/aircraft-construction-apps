ILR.Views ?= {}
class ILR.Views.Canvas extends Backbone.Poised.View
  tagName: 'canvas'

  # True if an animation frame request is currently pending
  animationFrameRequested: false

  requestRepaint: =>
    unless @animationFrameRequested
      @animationFrameRequested = true
      requestAnimationFrame =>
        @animationFrameRequested = false
        @render()
