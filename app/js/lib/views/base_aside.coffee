ILR.Views ?= {}
class ILR.Views.BaseAside extends Backbone.Poised.View
  tagName: 'aside'
  className: ->
    "#{@asideName} right"

  constructor: (options = {}) ->
    @asideName = options.name
    super
