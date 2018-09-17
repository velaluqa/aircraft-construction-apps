class Backbone.Poised.List.SelectableItem extends Backbone.Poised.List.Item
  events: _.defaults {
    'change [type=checkbox]': 'updateModelSelection'
    'tap': 'updateModelSelection'
    'press': 'toggleSingleSelection'
  }, Backbone.Poised.List.Item.prototype.events

  hammerjs:
    recognizers: [
      [Hammer.Rotate, { enable: false }],
      [Hammer.Pinch, { enable: false }, ['rotate']],
      [Hammer.Swipe, { enable: false }],
      [Hammer.Pan, { enable: false }, ['swipe']],
      [Hammer.Tap, { threshold: 5 }],
      [Hammer.Press]
    ]

  initialize: (options) ->
    super
    @options.singleSelect = options.singleSelect is true
    @model.on 'change:selected', @render

  updateCheckbox: =>
    @$checkbox.attr checked: @model.get('selected')

  updateModelSelection: (e) =>
    @model.set selected: !@model.get('selected')
    @model.collection.singleSelection = undefined
    @model.collection.selectedBeforeSingleSelection = undefined

  toggleSingleSelection: =>
    if @options.singleSelect
      if @model.collection.singleSelection is @model
        @model.collection.each (model) =>
          model.set selected: @model.collection.selectedBeforeSingleSelection.indexOf(model) > -1
        @model.collection.singleSelection = undefined
      else
        @model.collection.selectedBeforeSingleSelection ?= @model.collection.where(selected: true)
        @model.collection.singleSelection = @model
        @model.collection.each (model) =>
          model.set selected: (model is @model)

  render: =>
    super

    @$checkbox = $ '<input>',
      type: 'checkbox'
      name: "model_#{@model.cid}"
      checked: @model.get('selected')
    @$label = $ '<label>',
      for: "model_#{@model.cid}"
      class: 'checkbox'
    @$buttons.append(@$checkbox)
    @$buttons.append(@$label)

    this
