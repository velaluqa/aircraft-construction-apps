Backbone.Poised.List ||= {}
class Backbone.Poised.List.Anchor extends Backbone.Poised.View
  tagName: 'li'
  className: 'anchor'

  events:
    'click': 'toggleCollapse'

  initialize: (options = {}) ->
    super
    @name = options.name or 'general'
    @label = options.label

    @collapsible = options.collapsible is true
    @collapsed = options.collapsed isnt false if @collapsible

  toggleCollapse: =>
    @$el.toggleClass('collapsed')

  render: ->
    @$el.html @loadLocale "listAnchors.#{@name}.label",
      defaultValue: @name.toLabel()

    if @collapsible
      @$el.addClass('collapsible')
      @toggleCollapse() if @collapsed

    this
