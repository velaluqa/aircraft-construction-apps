ILR.LaminateDeformation ?= {}
ILR.LaminateDeformation.Models ?= {}
class ILR.LaminateDeformation.Models.App extends ILR.Models.BaseApp
  name: 'laminateDeformation'
  path: 'laminateDeformation'

  defaults: -> @loadAppSettings()

  initialize: ->
    # stepSize values for length and width are defined here
    # graph rendering relies on them and they should not be changed
    lengthFormField = @loadFormFieldSettings 'length', stepSize: 10
    widthFormField = @loadFormFieldSettings 'width', stepSize: 10
    minAspectRatio = lengthFormField.range[0] / widthFormField.range[1]
    maxAspectRatio = lengthFormField.range[1] / widthFormField.range[0]

    @formFields = [
      @loadFormFieldSettings 'laminate', options: _.keys(ILR.settings[@name].laminates)
      lengthFormField
      @loadFormFieldSettings 'aspectRatio',
        range: [minAspectRatio, maxAspectRatio],
        stepSize: minAspectRatio
      widthFormField
      @loadFormFieldSettings 'xLoad'
      @loadFormFieldSettings 'yLoad'
      @loadFormFieldSettings 'shearLoad'
      #@loadFormFieldSettings 'xMoment', type: 'value'
      #@loadFormFieldSettings 'yMoment', type: 'value'
      #@loadFormFieldSettings 'shearMoment', type: 'value'
    ]

    @initCurves [
      @loadCurveSettings 'xLoad',
        selected: true
      @loadCurveSettings 'axes'
      @loadCurveSettings 'yLoad',
        selected: true
      @loadCurveSettings 'shearLoad',
        selected: true
    ]

    calc = new ILR.LaminateDeformation.Models.Calculator(model: this)
    @set calculators: [calc]

    @listenTo calc, 'change:length change:width', =>
      @set aspectRatio: calc.aspectRatio()

    @on 'change:aspectRatio', =>
      width = @get('length') / @get('aspectRatio')
      tooSlim = width < widthFormField.range[0]
      tooWide = width > widthFormField.range[1]
      if tooSlim or tooWide
        if tooSlim
          width = widthFormField.range[0]
        else if tooWide
          width = widthFormField.range[1]
        length = Math.round(width * @get('aspectRatio') / 10) * 10
        @set length: length
      @set width: Math.round(width / 10) * 10

    super
