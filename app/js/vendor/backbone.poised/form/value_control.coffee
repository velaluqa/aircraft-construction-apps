class Backbone.Poised.ValueControl extends Backbone.Poised.BaseControl
  initialize: (options = {}) ->
    super

    @options = _.chain(options)
      .pick('model', 'attribute', 'unit', 'precision')
      .value()

  render: =>
    super

    @subviews.value = view = new Backbone.Poised.Value(@options)
    @$info.append(view.render().el)

    this
