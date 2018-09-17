class Backbone.Poised.Textfield extends Backbone.View
  className: 'poised textfield'

  events:
    'input input': 'changeAttributeValue'
    'focusin input': 'clearInputValue'
    'focusout input': 'updateInputValue'

  initialize: (options = {}) =>
    throw new Error('Missing `model` option') unless options.model?
    throw new Error('Missing `attribute` option') unless options.attribute?

    @attribute = options.attribute

    @options = _.chain(options)
      .pick('type', 'placeholder', 'autofocus', 'clearOnFocus', 'stepSize', 'precision', 'minValue', 'maxValue', 'unit', 'validate')
      .defaults
        type: 'text'
        autofocus: false
        clearOnFocus: false
        stepSize: 1
        precision: _.find [0..3], (i) ->
          (options.stepSize or 1) * Math.pow(10, i) >= 1
        minValue: null
        maxValue: null
        validate: true
      .value()

    if _.isArray(options.range)
      [@options.minValue, @options.maxValue] = options.range

    @model.on "change:#{@attribute}", @updateInputValue

  limit: (val) ->
    val = Math.max(val, @options.minValue) if @options.minValue?
    val = Math.min(val, @options.maxValue) if @options.maxValue?
    val

  changeAttributeValue: =>
    val = @$input.val()
    if @options.type is 'number'
      valid = val.match(/^[+\-]?\d+(\.\d+)?$/i)
      if valid?
        val = parseFloat(val)
        limitedVal = @limit(val)
        # We hit lower or upper limit. Update input with limited value.
        if limitedVal isnt val
          @$input.val(limitedVal.toFixed(@options.precision))
        @model.set @attribute, limitedVal
    else
      @model.set @attribute, val
    @model.validate(@attribute) if @model.validate and @options.validate

  updateInputValue: (model, value) =>
    unless @$('input').is(':focus')
      val = value or @model.get(@attribute)
      val = val.toFixed(@options.precision) if @options.type is 'number'
      @$input.val(val)
      @model.validate(@attribute) if @model.validate and @options.validate

  clearInputValue: =>
    @$input.val('') if @options.clearOnFocus

  render: =>
    @$el.empty()

    inputAttributes =
      class: 'poised'
      name: @attribute
      type: @options.type
      placeholder: @options.placeholder
      autofocus: @options.autofocus

    if @options.type is 'number'
      inputAttributes.min  = @options.minValue
      inputAttributes.max  = @options.maxValue
      inputAttributes.step = @options.stepSize

    @$input = $('<input />', inputAttributes).appendTo(@$el)

    @$el.append($('<abbr/>', text: @options.unit)) if @options.unit

    @updateInputValue()
    this
