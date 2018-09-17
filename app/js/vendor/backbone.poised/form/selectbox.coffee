class Backbone.Poised.Selectbox extends Backbone.Poised.View
  className: 'poised selectbox'

  events:
    'change select': 'changeAttributeValue'

  initialize: (options = {}) =>
    throw new Error('Missing `model` option') unless options.model?
    throw new Error('Missing `attribute` option') unless options.attribute?

    @attribute = options.attribute

    @options = _.chain(options)
      .pick('placeholder', 'options', 'multiselect', 'validate')
      .defaults
        placeholder: null
        options: []
        multiselect: false
        validate: true
      .value()

    @model.on "change:#{@attribute}", @updateSelectedOption

  changeAttributeValue: =>
    @model.set(@attribute, @$select.val())

  updateSelectedOption: (model, value) =>
    val = value or @model.get(@attribute)
    @$('select option').each (i, option) =>
      $option = $(option)
      if @options.multiselect
        $option.attr(selected: _.contains(val, $option.val()))
      else
        $option.attr(selected: val is $option.val())

  render: =>
    @$select = $ '<select />',
      class: 'poised'
      name: @attribute
      multiple: @options.multiselect

    if @options.placeholder
      @$select.append $ '<option>',
        value: ''
        text: @loadLocale "formFields.#{@attribute}.options.placeholder",
          defaultValue: @options.placeholder
        disabled: true

    for option in @options.options
      @$select.append $ '<option>',
        value: option
        text: @loadLocale "formFields.#{@attribute}.options.#{option}",
          defaultValue: option

    @$el.html(@$select)

    @updateSelectedOption()
    this
